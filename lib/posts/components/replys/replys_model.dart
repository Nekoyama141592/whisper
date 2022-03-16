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
  // indexDB
  String indexPostCommentId = '';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたはこのコメントに返信できません')));
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

  void showSortDialogue(BuildContext context,WhisperPostComment whisperComment) {
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
                final qshot = await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .orderBy(likeCountFieldKey,descending: true )
                .limit(oneTimeReadCount)
                .get();
                postCommentReplyDocs = qshot.docs;
                notifyListeners();
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
                sortState = SortState.byNewestFirst;
                final qshot = await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .orderBy(createdAtFieldKey,descending: true)
                .limit(oneTimeReadCount)
                .get();
                postCommentReplyDocs = qshot.docs;
                notifyListeners();
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
                sortState = SortState.byOldestFirst;
                final qshot = await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .orderBy(createdAtFieldKey,descending: false)
                .limit(oneTimeReadCount)
                .get();
                postCommentReplyDocs = qshot.docs;
                notifyListeners();
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
                Navigator.pop(context);
              }, 
              child: Text(
                'キャンセル',
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
    final qshot = await returnPostCommentRepliesColRef(postCreatorUid: whisperPostComment.passiveUid, postId: whisperPostComment.postId, postCommentId: whisperPostComment.postCommentId ).get();
    postCommentReplyDocs = qshot.docs;
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
      // QuerySnapshot<Map<String, dynamic>> newSnapshots = await returnPostCommentsColRef(postCreatorUid: whisperPost.uid,postId: whisperPost.postId,).orderBy(createdAtFieldKey,descending: true).endBeforeDocument(postCommentReplyDocs.first).limit(oneTimeReadCount).get();
      final qshot = await returnPostCommentRepliesColRef(postCreatorUid: whisperPostComment.passiveUid, postId: whisperPostComment.postId, postCommentId: whisperPostComment.postCommentId )
      .orderBy(createdAtFieldKey,descending: true)
      .endBeforeDocument(postCommentReplyDocs.first)
      .limit(oneTimeReadCount)
      .get();
      // Sort by oldest first
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
      docs.sort((a,b) => ( fromMapToWhisperReply(replyMap: a.data()).createdAt  as Timestamp ).compareTo( fromMapToWhisperReply(replyMap: b.data()).createdAt as Timestamp  ));
      // Insert at the top
      docs.forEach((doc) {
        postCommentReplyDocs.insert(0, doc);
      });
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> onLoading({ required WhisperPostComment whisperComment}) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .orderBy(likeCountFieldKey,descending: true )
      .startAfterDocument(postCommentReplyDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { 
          postCommentReplyDocs.add(doc); 
        });
      });
      break;
      case SortState.byNewestFirst:
      await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .orderBy(createdAtFieldKey,descending: true)
      .startAfterDocument(postCommentReplyDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { 
          postCommentReplyDocs.add(doc); 
        });
      });
      break;
      case SortState.byOldestFirst:
      await returnPostCommentRepliesColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .orderBy(createdAtFieldKey,descending: false)
      .startAfterDocument(postCommentReplyDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { 
          postCommentReplyDocs.add(doc); 
        });
      });
      break;
    }
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
      isDelete: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      likeCount: 0,
      mainWalletAddress: currentWhisperUser.mainWalletAddress,
      negativeScore: 0,
      passiveUid: whisperPost.uid,
      postId: whisperPost.postId,
      positiveScore: 0,
      reply: reply, 
      postCommentReplyId: replyId,
      postDocRef: returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ),
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userName: currentWhisperUser.userName,
      userImageURL: currentWhisperUser.userImageURL
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
      passiveUid: whisperComment.uid,
      postId: whisperComment.postId,
      postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId , postCommentId: whisperComment.postCommentId ) ,
      postDocRef: returnPostDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId ),
      reply: reply, 
      replyScore: newWhisperReply.score,
      postCommentReplyId: newWhisperReply.postCommentReplyId,
      notificationType: replyNotificationType,
      activeUid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.userImageURL,
      userName: currentWhisperUser.userName
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
  
  void reset() async {
    // postCommentReplyDocs = [];
    // notifyListeners();
    startLoading();
    Future.delayed(Duration(seconds: 3));
    endLoading();
  }
}