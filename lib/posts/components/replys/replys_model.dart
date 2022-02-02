// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flash/flash.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/nums.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
import 'package:whisper/domain/reply_like/reply_like.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/likeReply/like_reply.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// states
import 'package:whisper/constants/enums.dart';
// model
import 'package:whisper/main_model.dart';

final replysProvider = ChangeNotifierProvider(
  (ref) => ReplysModel()
);

class ReplysModel extends ChangeNotifier {

  String reply = "";
  String elementState = 'comment';
  bool isLoading = false;
  Map<String,dynamic> giveComment = {};
  // snapshots
  int limitIndex = oneTimeReadCount;
  late Stream<QuerySnapshot> replysStream;
  // IP
  String ipv6 = '';
  // refresh
  SortState sortState = SortState.byNewestFirst;
  late RefreshController refreshController;
  // indexDB
  String indexCommentId = '';
  void reload() {
    notifyListeners();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void onAddReplyButtonPressed({ required BuildContext context, required  Post whisperPost, required TextEditingController replyEditingController, required  WhisperComment whisperComment, required MainModel mainModel }) {
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

  void showMakeReplyInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController replyEditingController,required MainModel mainModel , required WhisperComment whisperComment}) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (reply.isEmpty) {
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

  void showSortDialogue(BuildContext context,WhisperComment whisperComment) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('リプライを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
                .orderBy(likeCountFieldKey,descending: true )
                .limit(limitIndex)
                .snapshots();
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
              onPressed: () {
                Navigator.pop(context);
                sortState = SortState.byNewestFirst;
                replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
                .orderBy(createdAtFieldKey,descending: true)
                .limit(limitIndex)
                .snapshots();
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
              onPressed: () {
                Navigator.pop(context);
                sortState = SortState.byOldestFirst;
                replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
                .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
                .orderBy(createdAtFieldKey,descending: false)
                .limit(limitIndex)
                .snapshots();
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

  

  void getReplysStream({ required BuildContext context, required WhisperComment whisperComment, required ReplysModel replysModel, required Post whisperPost, required MainModel mainModel })  {
    refreshController = RefreshController(initialRefresh: false);
    routes.toReplysPage(context: context, replysModel: replysModel, whisperPost: whisperPost, whisperComment: whisperComment, mainModel: mainModel);
    final String commentId = whisperComment.postCommentId ;
    try {
      if (indexCommentId != commentId) {
        indexCommentId = commentId;
        replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId ).where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId ).orderBy(createdAtFieldKey,descending: true).limit(limitIndex).snapshots();
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future onLoading({ required WhisperComment whisperComment}) async {
    limitIndex += oneTimeReadCount;
    switch(sortState) {
      case SortState.byLikedUidCount:
      replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
      .orderBy(likeCountFieldKey,descending: true )
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byNewestFirst:
      replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
      .orderBy(createdAtFieldKey,descending: true)
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byOldestFirst:
      replysStream = returnPostCommentReplysColRef(postCommentId: whisperComment.postCommentId,postCreatorUid: whisperComment.passiveUid,postId: whisperComment.postId )
      .where(elementIdFieldKey,isEqualTo: whisperComment.postCommentId )
      .orderBy(createdAtFieldKey,descending: false)
      .limit(limitIndex)
      .snapshots();
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }

  Future makeReply({ required Post whisperPost,required MainModel mainModel, required WhisperComment whisperComment}) async {
    final commentId = whisperComment.postCommentId ;
    final currentWhisperUser = mainModel.currentWhisperUser;
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final Timestamp now = Timestamp.now();
    final String postCommentReplyId = generatePostCommentReplyId(uid: mainModel.userMeta.uid);
    final WhisperReply newWhisperReply = makeWhisperReply(postCommentId: commentId, currentWhisperUser: currentWhisperUser, whisperPost: whisperPost, now: now, replyId: postCommentReplyId );
    await returnPostCommentReplyDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, postCommentId: whisperComment.postCommentId, postCommentReplyId: postCommentReplyId ).set(newWhisperReply.toJson());
    // notification
    if (whisperPost.uid != currentWhisperUser.uid) {
      await makeReplyNotification(elementId: commentId, mainModel: mainModel, whisperComment: whisperComment, newWhisperReply: newWhisperReply);
    }
  }

  WhisperReply makeWhisperReply({ required String postCommentId,required  WhisperUser currentWhisperUser, required Post whisperPost, required Timestamp now, required String replyId}) {
    final WhisperReply whisperReply = WhisperReply(
      accountName: currentWhisperUser.accountName,
      createdAt: now,
      postCommentId: postCommentId,
      followerCount: currentWhisperUser.followerCount,
      ipv6: ipv6, 
      isDelete: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      likeCount: 0,
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
      userImageURL: currentWhisperUser.imageURL
    );
    return whisperReply;
  }

  Future<void> makeReplyNotification({ required String elementId, required MainModel mainModel, required WhisperComment whisperComment, required WhisperReply newWhisperReply }) async {

    final currentWhisperUser = mainModel.currentWhisperUser;
    final String notificationId = returnNotificationId(notificationType: NotificationType.replyNotification );
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
      notificationId: notificationId, 
      passiveUid: whisperComment.uid,
      postId: whisperComment.postId,
      postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId , postCommentId: whisperComment.postCommentId ) ,
      postDocRef: returnPostDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId ),
      reply: reply, 
      replyScore: newWhisperReply.score,
      postCommentReplyId: newWhisperReply.postCommentReplyId,
      activeUid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.imageURL,
      userName: currentWhisperUser.userName
    );
    await returnNotificationDocRef(uid: whisperComment.uid,notificationId: notificationId).set(replyNotification.toJson());
  }

  Future<void> like({ required WhisperReply whisperReply, required MainModel mainModel }) async {
    // process UI
    final replyId = whisperReply.postCommentReplyId;
    final List<dynamic> likeReplyIds = mainModel.likeReplyIds;
    likeReplyIds.add(replyId);
    notifyListeners();
    // backend
  }

  Future<void> addLikeSubCol({ required WhisperReply whisperReply,required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final ReplyLike replyLike = ReplyLike(activeUid: mainModel.userMeta.uid, createdAt: now, replyId: whisperReply.postCommentReplyId );
    await returnPostCommentReplyLikeDocRef(postCreatorUid: whisperReply.uid, postId: whisperReply.postId, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId, activeUid: currentWhisperUser.uid ).set(replyLike.toJson());
  }


  Future<void> createLikeReplyTokenDoc({ required WhisperReply whisperReply, required MainModel mainModel}) async {
    try {
      mainModel.likeReplyIds.add(whisperReply.postCommentReplyId);
      notifyListeners();
      final String activeUid = mainModel.userMeta.uid;
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.likeReply );
      final LikeReply likeReply = LikeReply(activeUid: activeUid, createdAt: now,replyId: whisperReply.postCommentReplyId,tokenId: tokenId, postCommentReplyDocRef: (whisperReply.postDocRef as DocumentReference<Map<String,dynamic>> ).collection(postCommentsColRefName).doc(whisperReply.postCommentId).collection(postCommentReplysColRefName).doc(whisperReply.postCommentReplyId)  );
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(likeReply.toJson());
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> unlike({ required WhisperReply whisperReply, required MainModel mainModel }) async {
    final replyId = whisperReply.postCommentReplyId;
    final likeReplyIds = mainModel.likeReplyIds;
    // processUI
    likeReplyIds.remove(replyId);
    notifyListeners();
    // backend
  }

  Future<void> deleteLikeSubCol({ required WhisperReply whisperReply,required MainModel mainModel }) async {
    await returnPostCommentReplyLikeDocRef(postCreatorUid: whisperReply.uid, postId: whisperReply.postId, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId, activeUid: mainModel.userMeta.uid ).delete();
  }

  Future<void> deleteLikeReplyTokenDoc({ required MainModel mainModel, required WhisperReply whisperReply }) async {
    mainModel.likeReplyIds.remove(whisperReply.postId);
    notifyListeners();
    final String uid = mainModel.userMeta.uid;
    final deleteLikeReply = mainModel.likeReplys.where((element) => element.replyId == whisperReply.postCommentReplyId).toList().first;
    await returnTokenDocRef(uid: uid, tokenId: deleteLikeReply.tokenId ).delete();
  }
  
}