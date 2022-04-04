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
import 'package:whisper/constants/nums.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/reply_like/reply_like.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/likeReply/like_reply.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// states
import 'package:whisper/constants/enums.dart';
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
  // indexDB
  String indexPostCommentId = '';
  // hide
  List<String> isUnHiddenPostCommentReplyIds = [];

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
      voids.showSnackBar(context: context, text: 'あなたはこのコメントに返信できません');
    }
  }

  void showMakeReplyInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController replyEditingController,required MainModel mainModel , required WhisperPostComment whisperComment}) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (reply.isEmpty) {
            controller.dismiss();
          } else if (reply.length > maxCommentOrReplyLength) {
            controller.dismiss();
          } else {
            await makeReply(whisperPost: whisperPost, mainModel: mainModel, whisperComment: whisperComment);
            reply = '';
            replyEditingController.text = '';
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
    voids.showCommentOrReplyDialogue(context: context, title: 'リプライを入力', textEditingController: replyEditingController, onChanged: (text) { reply = text; }, oncloseButtonPressed: oncloseButtonPressed,send: send);
  }

  void showSortDialogue({ required BuildContext context, required WhisperPostComment whisperPostComment}) {
    showCupertinoDialog(
      context: context, 
      builder: (innerContext) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('リプライを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(innerContext);
                if (sortState != SortState.byLikedUidCount) {
                  sortState = SortState.byLikedUidCount;
                  await getReplyDocs(whisperPostComment: whisperPostComment);
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
                  await getReplyDocs(whisperPostComment: whisperPostComment);
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
                  await getReplyDocs(whisperPostComment: whisperPostComment);
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

  Future<void> getReplyDocs({ required WhisperPostComment whisperPostComment }) async {
    postCommentReplyDocs = [];
    await voids.processBasicDocs(query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
  }

  Future<void> onReload({ required WhisperPostComment whisperPostComment }) async {
    startLoading();
    await getReplyDocs(whisperPostComment: whisperPostComment);
    endLoading();
  }

  Future<void> onRefresh({ required WhisperPostComment whisperPostComment}) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      break;
      case SortState.byNewestFirst:
      await voids.processNewDocs(query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> onLoading({ required WhisperPostComment whisperPostComment}) async {
    await voids.processBasicDocs(query: getQuery(whisperPostComment: whisperPostComment), docs: postCommentReplyDocs );
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
      likeCount: 0,
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      muteCount: 0,
      nftIconInfo: {},
      passiveUid: whisperPost.uid,
      postId: whisperPost.postId,
      reply: reply, 
      replyLanguageCode: '',
      replyNegativeScore: 0,
      replyPositiveScore: 0,
      replySentiment: '',
      reportCount: 0,
      postCommentReplyId: replyId,
      postCreatorUid: whisperPost.uid,
      postDocRef: returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ),
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
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
      replyNegativeScore: 0,
      replyPositiveScore: 0,
      replySentiment: '',
      replyScore: newWhisperReply.score,
      postCommentReplyId: newWhisperReply.postCommentReplyId,
      notificationType: replyNotificationType,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
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

  Future<void> deleteMyReply({ required BuildContext context,required int i,required MainModel mainModel,}) async {
    final x = postCommentReplyDocs[i];
    if (WhisperReply.fromJson(x.data()!).uid == mainModel.currentWhisperUser.uid) {
      postCommentReplyDocs.remove(x);
      notifyListeners();
      await x.reference.delete();
    } else {
      voids.showSnackBar(context: context, text: 'あなたにはその権限がありません');
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
}