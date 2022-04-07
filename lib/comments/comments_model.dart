// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/domain/comment_like/comment_like.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/likeComment/like_comment.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/comment_mute/comment_mute.dart';
import 'package:whisper/domain/post_comment_report/post_comment_report.dart';
// states
import 'package:whisper/constants/enums.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};
  // comments
  List<DocumentSnapshot<Map<String,dynamic>>> commentDocs = [];
  // refresh
  SortState sortState = SortState.byNewestFirst;
  late RefreshController refreshController;
  Query<Map<String, dynamic>> getQuery ({ required Post whisperPost }) {
    final basicQuery = returnPostCommentsColRef(postCreatorUid: whisperPost.uid,postId: whisperPost.postId,).limit(oneTimeReadCount);
    switch(sortState) {
      case SortState.byLikedUidCount:
        final x = basicQuery.orderBy(likeCountFieldKey,descending: true);
      return x;
      case SortState.byNewestFirst:
        final x = basicQuery.orderBy(createdAtFieldKey,descending: true);
      return x;
      case SortState.byOldestFirst:
        final x = basicQuery.orderBy(createdAtFieldKey,descending: false);
      return x;
    }
  }
  // DB index
  String indexPostId = '';
  // hidden
  List<String> isUnHiddenPostCommentIds = [];
  // enum
  final BasicDocType basicDocType = BasicDocType.postComment;

  Future<void> init({ required BuildContext context, required AudioPlayer audioPlayer, required ValueNotifier<Post?> whisperPostNotifier, required MainModel mainModel,required Post whisperPost,required CommentsOrReplysModel commentsOrReplysModel }) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toCommentsPage(context: context, audioPlayer: audioPlayer, currentWhisperPostNotifier: whisperPostNotifier, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel );
    final String postId = whisperPost.postId;
    if (indexPostId != postId) {
      indexPostId = postId;
      await getCommentDocs(whisperPost: whisperPost);
    }
  }

  void onFloatingActionButtonPressed({ required BuildContext context, required Post whisperPost, required TextEditingController commentEditingController, required AudioPlayer audioPlayer, required MainModel mainModel }) {
    final String commentsState = whisperPost.commentsState;
    audioPlayer.pause();
    if (commentsState == returnCommentsStateString(commentsState: CommentsState.isOpen) ) {
      showMakeCommentInputFlashBar(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, mainModel: mainModel);
    } else {
      if (whisperPost.uid == mainModel.currentWhisperUser.uid ) {
        showMakeCommentInputFlashBar(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, mainModel: mainModel);
      } else {
        voids.showBasicFlutterToast(context: context, msg: 'コメントは投稿主しかできません');
      }
    }
  }

  void showMakeCommentInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController commentEditingController, required MainModel mainModel }) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (commentEditingController.text.isEmpty) {
            voids.showBasicFlutterToast(context: context, msg: emptyMsg );
            controller.dismiss();
          } else if (commentEditingController.text.length > maxCommentOrReplyLength){
            voids.showBasicFlutterToast(context: context, msg: maxCommentOrReplyMsg );
            controller.dismiss();
          } else {
            await makeComment(context: context, whisperPost: whisperPost, mainModel: mainModel);
            // after makeComment reset comment
            comment = '';
            commentEditingController.text = '';
            if (commentDocs.isNotEmpty) {
              voids.showBasicFlutterToast(context: context, msg: pleaseScrollMsg );
            }
            controller.dismiss();
          }
        },
        icon: Icon(Icons.send, color: Theme.of(context).primaryColor ),
      );
    };
    final void Function()? oncloseButtonPressed = () {
      comment = '';
      commentEditingController.text = '';
    };
    voids.showCommentOrReplyDialogue(context: context, title: 'コメントを入力',textEditingController: commentEditingController, onChanged: (text) { comment = text; }, oncloseButtonPressed: oncloseButtonPressed,send: send);
  }

  
  Future<void> makeComment({ required BuildContext context, required Post whisperPost, required MainModel mainModel }) async {
    final commentMap = makeCommentMap(mainModel: mainModel, whisperPost: whisperPost);
    final WhisperPostComment whisperComment = WhisperPostComment.fromJson(commentMap);
    await returnPostCommentDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, postCommentId: whisperComment.postCommentId).set(whisperComment.toJson());
    await voids.createUserMetaUpdateLog(mainModel: mainModel);
    // notification
    if (whisperPost.uid != mainModel.currentWhisperUser.uid ) {
      final Timestamp now = Timestamp.now();
      await makeCommentNotification( mainModel: mainModel, whisperComment: whisperComment,whisperPost: whisperPost, now: now );
    }
  }


  Map<String,dynamic> makeCommentMap({ required MainModel mainModel, required Post whisperPost }) {
    final WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final WhisperPostComment whisperComment = WhisperPostComment(
      accountName: currentWhisperUser.accountName,
      comment: comment, 
      commentLanguageCode: '',
      commentSentiment: '',
      commentNegativeScore: 0,
      commentPositiveScore: 0, 
      createdAt: now,
      followerCount: currentWhisperUser.followerCount,
      isHidden: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      isPinned: false,
      likeCount: 0,
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      masterReplied: false,
      muteCount: 0,
      nftIconInfo: {},
      passiveUid: whisperPost.uid,
      postCommentId: generatePostCommentId(uid: currentWhisperUser.uid ),
      postId: whisperPost.postId, 
      postCommentReplyCount: 0,
      reportCount: 0,
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userName: currentWhisperUser.userName,
      userImageURL: currentWhisperUser.userImageURL,
      userImageNegativeScore: 0,
      userNameLanguageCode: currentWhisperUser.userNameLanguageCode,
      userNameNegativeScore: currentWhisperUser.userNameNegativeScore,
      userNamePositiveScore: currentWhisperUser.userNamePositiveScore,
      userNameSentiment: currentWhisperUser.userNameSentiment,
    );
    Map<String,dynamic> commentMap = whisperComment.toJson();
    return commentMap;
  }

  Future<void> makeCommentNotification({ required Post whisperPost, required MainModel mainModel, required WhisperPostComment whisperComment, required Timestamp now }) async {
    final WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
    final String notificationId = returnNotificationId(notificationType: NotificationType.postCommentNotification);
    try{
      final CommentNotification commentNotification = CommentNotification(
        accountName: currentWhisperUser.accountName,
        activeUid: currentWhisperUser.uid,
        comment: comment, 
        commentLanguageCode: '',
        commentSentiment: '',
        commentNegativeScore: 0,
        commentPositiveScore: 0, 
        postCommentId: whisperComment.comment,
        commentScore: whisperComment.score,
        createdAt: now,
        followerCount: mainModel.currentWhisperUser.followerCount,
        isDelete: false,
        isNFTicon: currentWhisperUser.isNFTicon,
        isOfficial: currentWhisperUser.isOfficial,
        isRead: false,
        mainWalletAddress: currentWhisperUser.mainWalletAddress,
        nftIconInfo: {},
        notificationId: notificationId,
        passiveUid: whisperPost.uid,
        postId: whisperPost.postId,
        postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, postCommentId: whisperComment.postCommentId ),
        postDocRef: returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ),
        postTitle: whisperPost.title,
        notificationType: commentNotificationType,
        updatedAt: now,
        userImageURL: currentWhisperUser.userImageURL,
        userImageNegativeScore: 0,
        userName: currentWhisperUser.userName,
        userNameLanguageCode: currentWhisperUser.userNameLanguageCode,
        userNameNegativeScore: currentWhisperUser.userNameNegativeScore,
        userNamePositiveScore: currentWhisperUser.userNamePositiveScore,
        userNameSentiment: currentWhisperUser.userNameSentiment,
      );
      await returnNotificationDocRef(uid: whisperPost.uid, notificationId: notificationId).set(commentNotification.toJson());
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future<void> like({ required WhisperPostComment whisperComment, required MainModel mainModel}) async {
    // process set
    final postCommentId = whisperComment.postCommentId;
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.likePostComment );
    final LikeComment likeComment = LikeComment(
      activeUid: activeUid,
      postCommentId: whisperComment.postCommentId,
      createdAt: now,
      tokenId: tokenId,
      tokenType: likePostCommentTokenType,
      postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, postCommentId: whisperComment.postCommentId )
    );
    // processUi
    mainModel.likePostCommentIds.add(postCommentId);
    mainModel.likePostComments.add(likeComment);
    whisperComment.likeCount += plusOne;
    notifyListeners();
    // process back
    await addLikeSubCol(whisperComment: whisperComment,activeUid: activeUid ,now: now);
    await returnTokenDocRef(uid: activeUid, tokenId: tokenId).set(likeComment.toJson());
  }

  Future<void> addLikeSubCol({ required WhisperPostComment whisperComment,required String activeUid,required Timestamp now }) async {
    final postCommentDocRef = returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, postCommentId: whisperComment.postCommentId );
    final CommentLike commentLike = CommentLike(activeUid: activeUid, createdAt: now, postCommentId: whisperComment.postCommentId,postId: whisperComment.postId,postCommentCreatorUid: whisperComment.uid,postCommentDocRef: postCommentDocRef,  );
    await returnPostCommentLikeDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, activeUid: activeUid,postCommentId: whisperComment.postCommentId ).set(commentLike.toJson());
  }

  Future<void> unlike({ required WhisperPostComment whisperComment, required MainModel mainModel}) async {
    // process set
    final commentId = whisperComment.postCommentId;
    final deleteLikeComment = mainModel.likePostComments.where((element) => element.postCommentId == commentId ).toList().first;
    // process UI
    mainModel.likePostCommentIds.remove(commentId);
    mainModel.likePostComments.remove(deleteLikeComment);
    whisperComment.likeCount += minusOne;
    notifyListeners();
    // backend
    await returnPostCommentLikeDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, activeUid: mainModel.userMeta.uid,postCommentId: whisperComment.postCommentId).delete();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteLikeComment.tokenId ).delete();
  }

  void showSortDialogue({ required BuildContext context, required Post whisperPost}) {
    showCupertinoDialog(
      context: context, 
      builder: (innerContext) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('コメントを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikedUidCount) {
                  sortState = SortState.byLikedUidCount;
                  await getCommentDocs(whisperPost: whisperPost);
                }
              }, 
              child: Text(
                'いいね順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await getCommentDocs(whisperPost: whisperPost);
                }
              }, 
              child: Text(
                '新しい順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byOldestFirst) {
                  sortState = SortState.byOldestFirst;
                  await getCommentDocs(whisperPost: whisperPost);
                }
              }, 
              child: Text(
                '古い順',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(innerContext);
              }, 
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).highlightColor,
                ) 
              )
            ),
          ],
        );
      }
    );
  }

  Future<void> onRefresh({ required BuildContext context, required Post whisperPost}) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      break;
      case SortState.byNewestFirst:
      await voids.processNewDocs(basicDocType: basicDocType,query: getQuery(whisperPost: whisperPost), docs: commentDocs );
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> getCommentDocs({ required Post whisperPost }) async {
    commentDocs = [];
    await voids.processBasicDocs(basicDocType: basicDocType,docs: commentDocs,query: getQuery(whisperPost: whisperPost));
    notifyListeners();
  }

  Future<void> onLoading({ required Post whisperPost}) async {
    await voids.processOldDocs(basicDocType: basicDocType,query: getQuery(whisperPost: whisperPost), docs: commentDocs );
    notifyListeners();
    refreshController.loadComplete();
  }

  Future<void> deleteMyComment({ required BuildContext context,required DocumentSnapshot<Map<String,dynamic>> commentDoc,required MainModel mainModel,}) async {
    if (WhisperPostComment.fromJson(commentDoc.data()!).uid == mainModel.currentWhisperUser.uid ) {
      commentDocs.remove(commentDoc);
      notifyListeners();
      await commentDoc.reference.delete();
    } else {
      voids.showBasicFlutterToast(context: context, msg: 'あなたにはその権限がありません');
    }
  }
  void toggleIsHidden({ required WhisperPostComment whisperPostComment }) {
    final String id = whisperPostComment.postCommentId;
    if (isUnHiddenPostCommentIds.contains(id)) {
      isUnHiddenPostCommentIds.remove(id);
    } else {
      isUnHiddenPostCommentIds.add(id);
    }
    notifyListeners();
  }

  Future<void> muteComment({ required BuildContext context,required MainModel mainModel, required WhisperPostComment whisperComment,required DocumentSnapshot<Map<String,dynamic>> commentDoc }) async {
    if (mainModel.mutePostCommentIds.contains(whisperComment.postCommentId) == false) {
        // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.mutePostComment );
      final String postCommentId = whisperComment.postCommentId;
      final postCommentDocRef = returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, postCommentId: postCommentId, );
      final MuteComment muteComment = MuteComment(activeUid: mainModel.userMeta.uid,postCommentId: postCommentId,createdAt: now, tokenId: tokenId, tokenType: mutePostCommentTokenType,postCommentDocRef: postCommentDocRef, );
      // process UI
      mainModel.mutePostCommentIds.add(postCommentId);
      mainModel.mutePostComments.add(muteComment);
      commentDocs.remove(commentDoc);
      notifyListeners();
      await voids.showBasicFlutterToast(context: context,msg: mutePostCommentMsg);
      // process Backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteComment.toJson());
      final CommentMute commentMute = CommentMute(activeUid: mainModel.userMeta.uid, createdAt: now, postCommentId: postCommentId, postId: whisperComment.postId, postCommentCreatorUid: whisperComment.uid, postCommentDocRef: postCommentDocRef);
      await returnPostCommentMuteDocRef(postCommentDocRef: postCommentDocRef, userMeta: mainModel.userMeta).set(commentMute.toJson());
    } else {
      notifyListeners();
    }
  }

  void reportComment({ required BuildContext context,required MainModel mainModel, required WhisperPostComment whisperComment ,required DocumentSnapshot<Map<String,dynamic>> commentDoc }) {
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postCommentReportId = generatePostCommentReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostCommentReport postCommentReport = PostCommentReport(
            activeUid: mainModel.userMeta.uid, 
            comment: whisperComment.comment, 
            commentLanguageCode: whisperComment.commentLanguageCode,
            commentNegativeScore: whisperComment.commentNegativeScore,
            commentPositiveScore: whisperComment.commentPositiveScore,
            commentSentiment: whisperComment.commentSentiment,
            createdAt: Timestamp.now(), 
            others: '', 
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value), 
            passiveUid: whisperComment.uid,
            passiveUserName: whisperComment.userName,
            postCommentDocRef: commentDoc.reference,
            postCreatorUid: whisperComment.passiveUid,
            postId: whisperComment.postId,
          );
          await (controller as FlashController).dismiss();
          await voids.showBasicFlutterToast(context: context,msg: reportPostCommentMsg );
          await muteComment(context: context, mainModel: mainModel, whisperComment: whisperComment,commentDoc: commentDoc );
          await returnPostCommentReportDocRef(postCommentDoc: commentDoc, postCommentReportId: postCommentReportId).set(postCommentReport.toJson());
        }, 
        child: Text(choiceModalText, style: textStyle(context: context), )
      );
    };
    voids.showFlashDialogue(context: context, content: content, titleText: reportTitle, positiveActionBuilder: positiveActionBuilder);
  }

}