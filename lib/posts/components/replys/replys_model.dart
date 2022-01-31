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

  void onAddReplyButtonPressed({ required BuildContext context, required  Post whisperPost, required TextEditingController replyEditingController, required  Map<String,dynamic> thisComment, required MainModel mainModel }) {
    // コメントの投稿主が自分の場合
    // このPostの投稿主が自分の場合
    // このPostの投稿主とコメントの投稿主が一致している場合
    final currentWhisperUser = mainModel.currentWhisperUser;
    final WhisperComment whisperComment = WhisperComment.fromJson(thisComment);
    if (whisperComment.uid == currentWhisperUser.uid || whisperPost.uid == currentWhisperUser.uid || whisperComment.uid == whisperPost.uid) {
      showMakeReplyInputFlashBar(context: context, whisperPost: whisperPost, replyEditingController: replyEditingController, mainModel: mainModel, thisComment: thisComment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたはこのコメントに返信できません')));
    }
  }

  void showMakeReplyInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController replyEditingController,required MainModel mainModel , required Map<String,dynamic> thisComment}) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (reply.isEmpty) {
            controller.dismiss();
          } else {
            await makeReply(whisperPost: whisperPost, mainModel: mainModel, thisComment: thisComment);
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

  void showSortDialogue(BuildContext context,Map<String,dynamic> thisComment) {
    final WhisperComment whisperComment = WhisperComment.fromJson(thisComment);
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
                replysStream = FirebaseFirestore.instance
                .collection(replysFieldKey)
                .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
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
                replysStream = FirebaseFirestore.instance
                .collection(replysFieldKey)
                .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
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
                replysStream = FirebaseFirestore.instance
                .collection(replysFieldKey)
                .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
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

  

  void getReplysStream({ required BuildContext context, required Map<String,dynamic> thisComment, required ReplysModel replysModel, required Post whisperPost, required MainModel mainModel })  {
    refreshController = RefreshController(initialRefresh: false);
    routes.toReplysPage(context: context, replysModel: replysModel, whisperPost: whisperPost, thisComment: thisComment, mainModel: mainModel);
    final WhisperComment whisperComment = WhisperComment.fromJson(thisComment);
    final String commentId = whisperComment.commentId ;
    try {
      if (indexCommentId != commentId) {
        indexCommentId = commentId;
        replysStream = postCommentReplysColGroupQuery.where(elementIdFieldKey,isEqualTo: whisperComment.commentId ).orderBy(createdAtFieldKey,descending: true).limit(limitIndex).snapshots();
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future onLoading(Map<String,dynamic> thisComment) async {
    limitIndex += oneTimeReadCount;
    final WhisperComment whisperComment = WhisperComment.fromJson(thisComment);
    switch(sortState) {
      case SortState.byLikedUidCount:
      replysStream = FirebaseFirestore.instance
      .collection(replysFieldKey)
      .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
      .orderBy(likeCountFieldKey,descending: true )
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byNewestFirst:
      replysStream = FirebaseFirestore.instance
      .collection(replysFieldKey)
      .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
      .orderBy(createdAtFieldKey,descending: true)
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byOldestFirst:
      replysStream = FirebaseFirestore.instance
      .collection(replysFieldKey)
      .where(elementIdFieldKey,isEqualTo: whisperComment.commentId )
      .orderBy(createdAtFieldKey,descending: false)
      .limit(limitIndex)
      .snapshots();
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }

  Future makeReply({ required Post whisperPost,required MainModel mainModel, required Map<String,dynamic> thisComment}) async {
    final WhisperComment whisperComment = WhisperComment.fromJson(thisComment);
    final commentId = whisperComment.commentId ;
    final currentWhisperUser = mainModel.currentWhisperUser;
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final Timestamp now = Timestamp.now();
    final String replyId = 'reply' + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString();
    final WhisperReply newWhisperReply = makeWhisperReply(commentId: commentId, currentWhisperUser: currentWhisperUser, whisperPost: whisperPost, now: now, replyId: replyId );
    await postCommentReplyDocRef(uid: whisperPost.uid, postId: whisperPost.postId, postCommentId: whisperComment.commentId, postCommentReplyId: replyId ).set(newWhisperReply.toJson());
    // notification
    if (whisperPost.uid != currentWhisperUser.uid) {
      await makeReplyNotification(elementId: commentId, mainModel: mainModel, whisperComment: whisperComment, newWhisperReply: newWhisperReply);
    }
  }

  WhisperReply makeWhisperReply({ required String commentId,required  WhisperUser currentWhisperUser, required Post whisperPost, required Timestamp now, required String replyId}) {
    final WhisperReply whisperReply = WhisperReply(
      accountName: currentWhisperUser.accountName,
      createdAt: now,
      commentId: commentId,
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
      replyId: replyId,
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userName: currentWhisperUser.userName,
      userImageURL: currentWhisperUser.imageURL
    );
    return whisperReply;
  }

  Future<void> makeReplyNotification({ required String elementId, required , required MainModel mainModel, required WhisperComment whisperComment, required WhisperReply newWhisperReply }) async {

    final currentWhisperUser = mainModel.currentWhisperUser;
    final String notificationId = 'replyNotification' + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString();
    final comment = whisperComment.comment;
    final Timestamp now = Timestamp.now();
    final ReplyNotification replyNotification = ReplyNotification(
      accountName: currentWhisperUser.accountName,
      comment: comment, 
      createdAt: now,
      elementId: elementId, 
      elementState: elementState, 
      followerCount: currentWhisperUser.followerCount,
      isDelete: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      isRead: false,
      notificationId: notificationId, 
      passiveUid: whisperComment.uid,
      postId: whisperComment.postId,
      reply: reply, 
      replyScore: newWhisperReply.score,
      replyId: newWhisperReply.replyId,
      activeUid: currentWhisperUser.uid,
      updatedAt: now,
      userImageURL: currentWhisperUser.imageURL,
      userName: currentWhisperUser.userName
    );
    await notificationDocRef(uid: currentWhisperUser.uid, notificationId: notificationId).set(replyNotification.toJson());
  }

  Future<void> like({ required Map<String,dynamic> thisReply, required MainModel mainModel }) async {
    // process UI
    final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
    final replyId = whisperReply.replyId;
    final List<dynamic> likeReplyIds = mainModel.likeReplyIds;
    likeReplyIds.add(replyId);
    notifyListeners();
    // backend
    await addLikeSubCol(thisReply: thisReply, mainModel: mainModel);
    await createLikeReplyTokenDoc(thisReply: thisReply, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required Map<String,dynamic> thisReply,required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
    final Timestamp now = Timestamp.now();
    final ReplyLike replyLike = ReplyLike(activeUid: mainModel.userMeta.uid, createdAt: now, replyId: whisperReply.replyId );
    await postCommentReplyLikeDocRef(uid: whisperReply.uid, postId: whisperReply.postId, postCommentId: whisperReply.commentId, postCommentReplyId: whisperReply.replyId, activeUid: currentWhisperUser.uid ).set(replyLike.toJson());
  }


  Future<void> createLikeReplyTokenDoc({ required Map<String,dynamic> thisReply, required MainModel mainModel}) async {
    try {
      final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
      mainModel.likeReplyIds.add(whisperReply.replyId);
      notifyListeners();
      final String activeUid = mainModel.userMeta.uid;
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.likeReply );
      final LikeReply likeReply = LikeReply(activeUid: activeUid, createdAt: now,replyId: whisperReply.replyId,tokenId: tokenId);
      await tokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(likeReply.toJson());
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> unlike({ required Map<String,dynamic> thisReply, required MainModel mainModel }) async {
    final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
    final replyId = whisperReply.replyId;
    final likeReplyIds = mainModel.likeReplyIds;
    // processUI
    likeReplyIds.remove(replyId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(thisReply: thisReply, mainModel: mainModel);
    await deleteLikeReplyTokenDoc(mainModel: mainModel, thisReply: thisReply);
  }

  Future<void> deleteLikeSubCol({ required Map<String,dynamic> thisReply,required MainModel mainModel }) async {
    final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
    await postCommentReplyLikeDocRef(uid: whisperReply.uid, postId: whisperReply.postId, postCommentId: whisperReply.commentId, postCommentReplyId: whisperReply.replyId, activeUid: mainModel.userMeta.uid ).delete();
  }

  Future<void> deleteLikeReplyTokenDoc({ required MainModel mainModel, required Map<String,dynamic> thisReply }) async {
    final WhisperReply whisperReply = WhisperReply.fromJson(thisReply);
    mainModel.likeReplyIds.remove(whisperReply.postId);
    notifyListeners();
    final String uid = mainModel.userMeta.uid;
    final deleteLikeReply = mainModel.likeReplys.where((element) => element.replyId == whisperReply.replyId).toList().first;
    await tokenDocRef(uid: uid, tokenId: deleteLikeReply.tokenId ).delete();
  }
  
}