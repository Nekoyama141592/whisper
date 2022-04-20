// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/details/positive_text.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/reply_like/reply_like.dart';
import 'package:whisper/domain/likeReply/like_reply.dart';
import 'package:whisper/domain/mute_reply/mute_reply.dart';
import 'package:whisper/domain/reply_mute/reply_mute.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/post_comment_reply_report/post_comment_reply_report.dart';
// states
import 'package:whisper/constants/enums.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

final repliesProvider = ChangeNotifierProvider(
  (ref) => RepliesModel()
);

class RepliesModel extends ChangeNotifier {

  String reply = "";
  bool isLoading = false;
  Map<String,dynamic> giveComment = {};
  // docs
  List<DocumentSnapshot<Map<String,dynamic>>> postCommentReplyDocs = [];
  // refresh
  SortState sortState = SortState.byNewestFirst;
  late RefreshController refreshController;
  Query<Map<String, dynamic>> getQuery ({ required WhisperPostComment whisperPostComment }) {
    final basicQuery = returnPostCommentRepliesColRef(postCommentId: whisperPostComment.postCommentId,postCreatorUid: whisperPostComment.passiveUid,postId: whisperPostComment.postId ).limit(oneTimeReadCount);
    switch(sortState) {
      case SortState.byLikeUidCount:
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
  // indexDB
  String indexPostCommentId = '';
  // hide
  List<String> isUnHiddenPostCommentReplyIds = [];
  // enum
  final BasicDocType basicDocType = BasicDocType.postCommentReply;

  Future<void> init({ required BuildContext context, required MainModel mainModel, required Post whisperPost,required WhisperPostComment whisperPostComment,required CommentsOrReplysModel commentsOrReplysModel }) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toReplysPage(context: context,whisperPost: whisperPost, whisperPostComment: whisperPostComment, mainModel: mainModel, commentsOrReplysModel: commentsOrReplysModel);
    final postCommentId = whisperPostComment.postCommentId;
    if (indexPostCommentId != postCommentId ) {
      indexPostCommentId = postCommentId ;
      await getReplyDocs( whisperPostComment: whisperPostComment );
      notifyListeners();
    }
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onAddReplyButtonPressed({ required BuildContext context, required  Post whisperPost, required TextEditingController replyEditingController, required  WhisperPostComment whisperComment, required MainModel mainModel }) {
    // コメントの投稿主が自分の場合
    // このPostの投稿主が自分の場合
    // このPostの投稿主とコメントの投稿主が一致している場合
    final currentWhisperUser = mainModel.currentWhisperUser;
    if (whisperComment.uid == currentWhisperUser.uid || whisperPost.uid == currentWhisperUser.uid || whisperComment.uid == whisperPost.uid) {
      showMakeReplyInputFlashBar(context: context, whisperPost: whisperPost, replyEditingController: replyEditingController, mainModel: mainModel, whisperComment: whisperComment);
    } else {
      voids.showBasicFlutterToast(context: context, msg: cannotReplyMsg);
    }
  }

  void showMakeReplyInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController replyEditingController,required MainModel mainModel , required WhisperPostComment whisperComment}) {
    final toastColor = Theme.of(context).colorScheme.secondary;
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          final L10n l10n = returnL10n(context: context)!;
          if (reply.isEmpty) {
            voids.showCustomFlutterToast(backgroundColor: toastColor, msg: emptyMsg );
            controller.dismiss();
          } else if (reply.length > maxCommentOrReplyLength) {
            voids.showCustomFlutterToast(backgroundColor: toastColor, msg: l10n.commentOrReplyLimit(maxCommentOrReplyLength.toString()) );
            controller.dismiss();
          } else {
            await makeReply(whisperPost: whisperPost, mainModel: mainModel, whisperComment: whisperComment);
            // after makeReply reset reply
            reply = '';
            replyEditingController.text = '';
            if (postCommentReplyDocs.isNotEmpty) {
              voids.showCustomFlutterToast(backgroundColor: toastColor, msg: pleaseScrollMsg );
            }
            controller.dismiss();
          }
        },
        icon: Icon(Icons.send, color: Theme.of(context).primaryColor ),
      );
    };
    final void Function()? oncloseButtonPressed = () {
      reply = '';
      replyEditingController.text = '';
    };
    voids.showCommentOrReplyDialogue(context: context, title: inputReplyText, textEditingController: replyEditingController, onChanged: (text) { reply = text; }, oncloseButtonPressed: oncloseButtonPressed,send: send);
  }

  void showSortDialogue({ required BuildContext context, required WhisperPostComment whisperPostComment}) {
    showCupertinoDialog(
      context: context, 
      builder: (innerContext) {
        return CupertinoActionSheet(
          title: PositiveText(text: sortText),
          message: PositiveText(text: sortReplyText),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikeUidCount) {
                  sortState = SortState.byLikeUidCount;
                  await getReplyDocs(whisperPostComment: whisperPostComment);
                  await reflectChanges(context: context);
                }
              }, 
              child: PositiveText(text: sortByLikeUidCountText),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await getReplyDocs(whisperPostComment: whisperPostComment);
                  await reflectChanges(context: context);
                }
              }, 
              child: PositiveText(text: sortByNewestFirstText),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byOldestFirst) {
                  sortState = SortState.byOldestFirst;
                  await getReplyDocs(whisperPostComment: whisperPostComment);
                  await reflectChanges(context: context);
                }
              }, 
              child: PositiveText(text: sortByOldestFirstText),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(innerContext),
              child: PositiveText(text: cancelText),
            ),
          ],
        );
      }
    );
  }

  Future<void> getReplyDocs({ required WhisperPostComment whisperPostComment }) async {
    postCommentReplyDocs = [];
    await voids.processBasicDocs(basicDocType: basicDocType,query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
  }

  Future<void> onReload({ required WhisperPostComment whisperPostComment }) async {
    startLoading();
    await getReplyDocs(whisperPostComment: whisperPostComment);
    endLoading();
  }

  Future<void> onRefresh({ required WhisperPostComment whisperPostComment }) async {
    switch(sortState) {
      case SortState.byLikeUidCount:
      break;
      case SortState.byNewestFirst:
      await voids.processNewDocs(basicDocType: basicDocType,query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> onLoading({ required WhisperPostComment whisperPostComment }) async {
    await voids.processOldDocs(basicDocType: basicDocType,query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
    notifyListeners();
    refreshController.loadComplete();
  }

  Future makeReply({ required Post whisperPost,required MainModel mainModel, required WhisperPostComment whisperComment}) async {
    final commentId = whisperComment.postCommentId ;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final String postCommentReplyId = generatePostCommentReplyId(uid: mainModel.userMeta.uid);
    final WhisperReply newWhisperReply = makeWhisperReply(postCommentId: commentId, currentWhisperUser: currentWhisperUser, whisperPost: whisperPost, now: now, replyId: postCommentReplyId );
    await returnPostCommentReplyDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, postCommentId: whisperComment.postCommentId, postCommentReplyId: postCommentReplyId ).set(newWhisperReply.toJson());
    await voids.createUserMetaUpdateLog(mainModel: mainModel);
    // notification
    if (whisperComment.uid != currentWhisperUser.uid) {
      await makeReplyNotification(elementId: commentId, mainModel: mainModel, whisperComment: whisperComment, newWhisperReply: newWhisperReply);
    }
  }

  WhisperReply makeWhisperReply({ required String postCommentId,required  WhisperUser currentWhisperUser, required Post whisperPost, required Timestamp now, required String replyId}) {
    final WhisperReply whisperReply = WhisperReply(
      accountName: currentWhisperUser.accountName,
      createdAt: now,
      postCommentId: postCommentId,
      followerCount: currentWhisperUser.followerCount,
      isHidden: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      isPinned: false,
      likeCount: initialCount,
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      muteCount: initialCount,
      nftIconInfo: {},
      passiveUid: whisperPost.uid,
      postId: whisperPost.postId,
      reply: reply, 
      replyLanguageCode: '',
      replyNegativeScore: initialNegativeScore,
      replyPositiveScore: initialPositiveScore,
      replySentiment: '',
      reportCount: initialCount,
      postCommentReplyId: replyId,
      postCreatorUid: whisperPost.uid,
      postDocRef: returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ),
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
      userImageNegativeScore: initialNegativeScore,
      userName: currentWhisperUser.userName,
      userNameLanguageCode: currentWhisperUser.userNameLanguageCode,
      userNameNegativeScore: currentWhisperUser.userNameNegativeScore,
      userNamePositiveScore: currentWhisperUser.userNamePositiveScore,
      userNameSentiment: currentWhisperUser.userNameSentiment,
    );
    return whisperReply;
  }

  Future<void> makeReplyNotification({ required String elementId, required MainModel mainModel, required WhisperPostComment whisperComment, required WhisperReply newWhisperReply }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final String notificationId = returnNotificationId(notificationType: NotificationType.postCommentReplyNotification );
    final comment = whisperComment.comment;
    final Timestamp now = Timestamp.now();
    final ReplyNotification replyNotification = ReplyNotification(
      accountName: currentWhisperUser.accountName,
      activeUid: currentWhisperUser.uid,
      comment: comment, 
      createdAt: now,
      postCommentId: elementId, 
      followerCount: currentWhisperUser.followerCount,
      isDelete: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      isRead: false,
      masterReplied: whisperComment.passiveUid == currentWhisperUser.uid,
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      notificationId: notificationId,
      nftIconInfo: {}, 
      passiveUid: whisperComment.uid,
      postId: whisperComment.postId,
      postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId , postCommentId: whisperComment.postCommentId ) ,
      postDocRef: returnPostDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId ),
      reply: reply, 
      replyLanguageCode: '',
      replyNegativeScore: initialNegativeScore,
      replyPositiveScore: initialPositiveScore,
      replySentiment: '',
      replyScore: newWhisperReply.score,
      postCommentReplyId: newWhisperReply.postCommentReplyId,
      notificationType: replyNotificationType,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
      userImageNegativeScore: initialNegativeScore,
      userName: currentWhisperUser.userName,
      userNameLanguageCode: currentWhisperUser.userNameLanguageCode,
      userNameNegativeScore: currentWhisperUser.userNameNegativeScore,
      userNamePositiveScore: currentWhisperUser.userNamePositiveScore,
      userNameSentiment: currentWhisperUser.userNameSentiment,
    );
    await returnNotificationDocRef(uid: whisperComment.uid,notificationId: notificationId).set(replyNotification.toJson());
  }

  Future<void> like({ required WhisperReply whisperReply, required MainModel mainModel }) async {
    // process set
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.likePostCommentReply );
    // process UI
    final userMeta = mainModel.userMeta;
    final postCommentReplyId = whisperReply.postCommentReplyId;
    final LikeReply likeReply = LikeReply(activeUid: userMeta.uid, createdAt: now,postCommentReplyId: whisperReply.postCommentReplyId,tokenId: tokenId, tokenType: likePostCommentReplyTokenType, postCommentReplyDocRef: (whisperReply.postDocRef as DocumentReference<Map<String,dynamic>> ).collection(postCommentsColRefName).doc(whisperReply.postCommentId).collection(postCommentRepliesColRefName).doc(whisperReply.postCommentReplyId)  );
    mainModel.likePostCommentReplyIds.add(postCommentReplyId);
    mainModel.likePostCommentReplies.add(likeReply);
    whisperReply.likeCount += plusOne;
    notifyListeners();
    // backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(likeReply.toJson());
    await addLikeSubCol(whisperReply: whisperReply, mainModel: mainModel, now: now);
  }

  Future<void> addLikeSubCol({ required WhisperReply whisperReply,required MainModel mainModel,required Timestamp now }) async {
    final userMeta = mainModel.userMeta;
    final postCommentReplyDocRef = postDocRefToPostCommentReplyDocRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId );
    final ReplyLike replyLike = ReplyLike(activeUid: userMeta.uid, createdAt: now, postCommentReplyId: whisperReply.postCommentReplyId,postCommentReplyDocRef: postCommentReplyDocRef,postCommentReplyCreatorUid: whisperReply.uid, );
    await postDocRefToPostCommentReplyLikeRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId, userMeta: userMeta).set(replyLike.toJson());
  }


  Future<void> unlike({ required WhisperReply whisperReply, required MainModel mainModel }) async {
    // process set
    final postCommentReplyId = whisperReply.postCommentReplyId;
    final deleteLikeReply = mainModel.likePostCommentReplies.where((element) => element.postCommentReplyId == whisperReply.postCommentReplyId).toList().first;
    // processUI
    mainModel.likePostCommentReplyIds.remove(postCommentReplyId);
    mainModel.likePostCommentReplies.remove(deleteLikeReply);
    whisperReply.likeCount += minusOne;
    notifyListeners();
    // backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteLikeReply.tokenId ).delete();
    await postDocRefToPostCommentReplyLikeRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: postCommentReplyId, userMeta: mainModel.userMeta ).delete();
  }

  Future<void> deleteMyReply({ required BuildContext context,required DocumentSnapshot<Map<String,dynamic>> replyDoc,required MainModel mainModel,}) async {
    if (WhisperReply.fromJson(replyDoc.data()!).uid == mainModel.currentWhisperUser.uid) {
      postCommentReplyDocs.remove(replyDoc);
      notifyListeners();
      await replyDoc.reference.delete();
    } else {
      await voids.showBasicFlutterToast(context: context, msg: dontHaveRightMsg );
    }
  }
  
  void toggleIsHidden({ required WhisperReply whisperReply }) {
    final String id = whisperReply.postCommentReplyId;
    if (isUnHiddenPostCommentReplyIds.contains(id)) {
      isUnHiddenPostCommentReplyIds.remove(id);
    } else {
      isUnHiddenPostCommentReplyIds.add(id);
    }
    notifyListeners();
  }

  Future<void> muteReply({ required BuildContext context,required MainModel mainModel, required WhisperReply whisperReply,required DocumentSnapshot<Map<String,dynamic>> replyDoc }) async {
    if (mainModel.mutePostCommentReplyIds.contains(whisperReply.postCommentReplyId) == false) {
      // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePostCommentReply );
      final postCommentReplyDocRef = postDocRefToPostCommentReplyDocRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId );
      final MuteReply muteReply = MuteReply(activeUid: mainModel.userMeta.uid, createdAt: now, postCommentReplyId: whisperReply.postCommentReplyId, tokenType: mutePostCommentReplyTokenType, postCommentReplyDocRef: postCommentReplyDocRef );
      // process UI
      mainModel.mutePostCommentReplyIds.add(muteReply.postCommentReplyId);
      mainModel.mutePostCommentReplys.add(muteReply);
      postCommentReplyDocs.remove(replyDoc);
      notifyListeners();
      await voids.showCustomFlutterToast(backgroundColor: Theme.of(context).colorScheme.secondary,msg: mutePostCommentReplyMsg);
      // process Backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteReply.toJson());
      final ReplyMute replyMute = ReplyMute(activeUid: mainModel.userMeta.uid, createdAt: now, postCommentReplyCreatorUid: whisperReply.uid, postCommentReplyId: whisperReply.postCommentReplyId, postCommentReplyDocRef: postCommentReplyDocRef);
      await returnPostCommentReplyMuteDocRef(postCommentReplyDocRef: postCommentReplyDocRef, userMeta: mainModel.userMeta).set(replyMute.toJson());
    } else {
      notifyListeners();
    }
  }
  
  void reportReply({ required BuildContext context,required MainModel mainModel, required WhisperReply whisperReply,required DocumentSnapshot<Map<String,dynamic>> replyDoc }) {
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final postCommentReplyReportId = generatePostCommentReplyReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostCommentReplyReport postCommentReplyReport = PostCommentReplyReport(
            activeUid: mainModel.userMeta.uid,
            createdAt: Timestamp.now(),
            others: '',
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value), 
            passiveUid: whisperReply.uid,
            passiveUserName: whisperReply.userName, 
            postCommentId: whisperReply.postCommentId, 
            postCommentReplyId: whisperReply.postCommentReplyId, 
            postCommentReplyDocRef: replyDoc.reference, 
            postCreatorUid: whisperReply.postCreatorUid, 
            postId: whisperReply.postId, 
            reply: whisperReply.reply, 
            replyLanguageCode: whisperReply.replyLanguageCode, 
            replyNegativeScore: whisperReply.replyNegativeScore, 
            replyPositiveScore: whisperReply.replyPositiveScore, 
            replySentiment: whisperReply.replySentiment
          );
          await (controller as FlashController).dismiss();
          await voids.showCustomFlutterToast(backgroundColor: Theme.of(context).highlightColor,msg: reportPostCommentReplyMsg );
          await muteReply(context: context, mainModel: mainModel, whisperReply: whisperReply,replyDoc: replyDoc,);
          await returnPostCommentReplyReportDocRef(postCommentReplyDoc: replyDoc, postCommentReplyReportId: postCommentReplyReportId).set(postCommentReplyReport.toJson());
        }, 
        child: PositiveText(text: sendModalText)
      );
    };
    voids.showFlashDialogue(context: context, content: content, titleText: reportTitle, positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> reflectChanges({ required BuildContext context }) async {
    await voids.showBasicFlutterToast(context: context, msg: reflectChangesMsg);
  }

}