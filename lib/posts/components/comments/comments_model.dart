// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/nums.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/likeComment/like_comment.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// states
import 'package:whisper/constants/enums.dart';
// models
import 'package:whisper/main_model.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};
  // comments
  List<DocumentSnapshot<Map<String,dynamic>>> commentDocs = [];
  // IP
  String ipv6 = '';
  // refresh
  SortState sortState = SortState.byNewestFirst;
  late RefreshController refreshController;
  // DB index
  String indexPostId = '';

  void reload() {
    notifyListeners();
  }

  Future<void> init(BuildContext context,AudioPlayer audioPlayer,ValueNotifier<Map<String,dynamic>> whisperPostNotifier,MainModel mainModel,String postId) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toCommentsPage(context, audioPlayer, whisperPostNotifier, mainModel);
    if (indexPostId != postId) {
      indexPostId = postId;
      await getCommentDocs(postId);
    }
  }

  Future<void> getCommentDocs(String postId) async {
    commentDocs = [];
    await FirebaseFirestore.instance.collection(commentsFieldKey).where(postIdFieldKey,isEqualTo: postId).orderBy(createdAtFieldKey,descending: true).limit(oneTimeReadCount).get().then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
    });
    notifyListeners();
  }

  void onFloatingActionButtonPressed({ required BuildContext context, required Post whisperPost, required TextEditingController commentEditingController, required AudioPlayer audioPlayer, required MainModel mainModel }) {
    final String commentsState = whisperPost.commentsState;
    audioPlayer.pause();
    switch(commentsState){
      case 'open':
      showMakeCommentInputFlashBar(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, mainModel: mainModel);
      break;
      case 'isLocked':
      if (whisperPost.uid == mainModel.currentWhisperUser.uid ) {
        showMakeCommentInputFlashBar(context: context, whisperPost: whisperPost, commentEditingController: commentEditingController, mainModel: mainModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
    }
  }

  void showMakeCommentInputFlashBar({ required BuildContext context, required Post whisperPost, required TextEditingController commentEditingController, required MainModel mainModel }) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (commentEditingController.text.isEmpty) {
            controller.dismiss();
          } else {
            await makeComment(context: context, whisperPost: whisperPost, mainModel: mainModel);
            comment = '';
            commentEditingController.text = '';
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
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final commentMap = makeCommentMap(mainModel: mainModel, whisperPost: whisperPost);
    final whisperComment = fromMapToWhisperComment(commentMap: commentMap);
    await FirebaseFirestore.instance.collection(commentsFieldKey).doc(whisperComment.commentId).set(commentMap);
    // notification
    if (whisperPost.uid != mainModel.currentWhisperUser.uid ) {
      final Timestamp now = Timestamp.now();
      await makeCommentNotification( mainModel: mainModel, whisperComment: whisperComment,whisperPost: whisperPost, now: now );
    }
  }


  Map<String,dynamic> makeCommentMap({ required MainModel mainModel, required Post whisperPost }) {
    final WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
    final Timestamp now = Timestamp.now();
    final WhisperComment whisperComment = WhisperComment(
      accountName: currentWhisperUser.accountName,
      comment: comment, 
      commentId: 'comment' + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: now,
      followerCount: currentWhisperUser.followerCount,
      ipv6: ipv6, 
      isDelete: false,
      isNFTicon: currentWhisperUser.isNFTicon,
      isOfficial: currentWhisperUser.isOfficial,
      likeCount: 0,
      negativeScore: 0,
      passiveUid: whisperPost.uid,
      positiveScore: 0, 
      postId: whisperPost.postId, 
      replyCount: 0,
      score: defaultScore,
      uid: currentWhisperUser.uid,
      updatedAt: now,
      userName: currentWhisperUser.userName,
      userImageURL: currentWhisperUser.imageURL
    );
    Map<String,dynamic> commentMap = whisperComment.toJson();
    return commentMap;
  }

  Future<void> makeCommentNotification({ required Post whisperPost, required MainModel mainModel, required WhisperComment whisperComment, required Timestamp now }) async {
    final WhisperUser currentWhisperUser = mainModel.currentWhisperUser;
    try{
      final CommentNotification commentNotification = CommentNotification(
        accountName: currentWhisperUser.accountName,
        comment: comment, 
        commentId: whisperComment.comment,
        commentScore: whisperComment.score,
        createdAt: now,
        followerCount: mainModel.currentWhisperUser.followerCount,
        isDelete: false,
        isNFTicon: currentWhisperUser.isNFTicon,
        isOfficial: currentWhisperUser.isOfficial,
        isRead: false,
        notificationId: 'commentNotification' + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString(),
        passiveUid: whisperPost.uid,
        postTitle: whisperPost.title,
        postId: whisperPost.postId,
        activeUid: currentWhisperUser.uid,
        updatedAt: now,
        userImageURL: currentWhisperUser.imageURL,
        userName: currentWhisperUser.userName
      );
      await newNotificationChildRef(uid: currentWhisperUser.uid, now: now).set(commentNotification.toJson());
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future<void> like({ required WhisperComment whisperComment, required MainModel mainModel}) async {
    final commentId = whisperComment.commentId;
    // processUi
    final likeCommentIds = mainModel.likeCommentIds;
    likeCommentIds.add(commentId);
    notifyListeners();
    await addLikeSubCol(whisperComment: whisperComment, mainModel: mainModel);
    await createLikeCommentDoc(commentId: commentId, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required WhisperComment whisperComment,required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final LikeComment likeComment = LikeComment(activeUid: currentWhisperUser.uid,createdAt: Timestamp.now(),commentId: whisperComment.commentId);
    await likeChildRef(parentColKey: commentsFieldKey, uniqueId: whisperComment.commentId , activeUid: currentWhisperUser.uid ).set(likeComment.toJson());
  }

  Future<void> createLikeCommentDoc({ required String commentId, required MainModel mainModel }) async {
    final activeUid = mainModel.userMeta.uid;
    final now = DateTime.now();
    final LikeComment likeComment = LikeComment(
      activeUid: activeUid,
      commentId: commentId,
      createdAt: Timestamp.fromDate(now),
    );
    await newTokenChildRef(uid: activeUid, now: now).set(likeComment.toJson());
  }

  Future<void> unlike({ required WhisperComment whisperComment, required MainModel mainModel}) async {
    // process UI
    final commentId = whisperComment.commentId;
    final likeCommentIds = mainModel.likeCommentIds;
    likeCommentIds.remove(commentId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(whisperComment: whisperComment, mainModel: mainModel);
    await removeLikedCommentsFromCurrentUser(commentId: commentId, mainModel: mainModel);
  }

  Future<void> deleteLikeSubCol({ required WhisperComment whisperComment,required MainModel mainModel }) async {
    await likeChildRef(parentColKey: commentsFieldKey, uniqueId: whisperComment.commentId , activeUid: mainModel.currentWhisperUser.uid ).delete();
  }

  Future<void> removeLikedCommentsFromCurrentUser({ required String commentId,required MainModel mainModel}) async {
    final String uid = mainModel.userMeta.uid;
    final qshot = await tokensParentRef(uid: uid).where(commentId,isEqualTo: commentId).limit(plusOne).get();
    await tokensParentRef(uid: uid).doc(qshot.docs.first.id).delete();
  }

  void showSortDialogue(BuildContext context,Post whisperPost) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        final postId = whisperPost.postId;
        return CupertinoActionSheet(
          title: Text('並び替え',style: TextStyle(fontWeight: FontWeight.bold)),
          message: Text('コメントを並び替えます',style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byLikedUidCount;
                await FirebaseFirestore.instance
                .collection(commentsFieldKey)
                .where(postIdFieldKey,isEqualTo: postId)
                .orderBy(likeCountFieldKey,descending: true )
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
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
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byNewestFirst;
                await FirebaseFirestore.instance
                .collection(commentsFieldKey)
                .where(postIdFieldKey,isEqualTo: postId)
                .orderBy(createdAtFieldKey,descending: true)
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
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
                Navigator.pop(context);
                commentDocs = [];
                sortState = SortState.byOldestFirst;
                await FirebaseFirestore.instance
                .collection(commentsFieldKey)
                .where(postIdFieldKey,isEqualTo: postId)
                .orderBy(createdAtFieldKey,descending: false)
                .limit(oneTimeReadCount)
                .get().then((qshot) {
                  qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
                });
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

  Future<void> onRefresh(BuildContext context,Post whisperPost) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      break;
      case SortState.byNewestFirst:
      QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
      .collection(commentsFieldKey)
      .where(postIdFieldKey,isEqualTo: whisperPost.postId)
      .orderBy(createdAtFieldKey,descending: true)
      .endBeforeDocument(commentDocs[0])
      .limit(oneTimeReadCount)
      .get();
      // Sort by oldest first
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
      docs.sort((a,b) => (a[createdAtFieldKey] as Timestamp ).compareTo(b[createdAtFieldKey]));
      // Insert at the top
      docs.forEach((doc) {
        commentDocs.insert(0, doc);
      });
      break;
      case SortState.byOldestFirst:
      break;
    }
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future<void> onLoading(Post whisperPost) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      await FirebaseFirestore.instance
      .collection(commentsFieldKey)
      .where(postIdFieldKey,isEqualTo: whisperPost.postId)
      .orderBy(likeCountFieldKey,descending: true )
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { 
          commentDocs.add(doc); 
        });
      });
      break;
      case SortState.byNewestFirst:
      await FirebaseFirestore.instance
      .collection(commentsFieldKey)
      .where(postIdFieldKey,isEqualTo: whisperPost.postId)
      .orderBy(createdAtFieldKey,descending: true)
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
      });
      break;
      case SortState.byOldestFirst:
      await FirebaseFirestore.instance
      .collection(commentsFieldKey)
      .where(postIdFieldKey,isEqualTo: whisperPost.postId)
      .orderBy(createdAtFieldKey,descending: false)
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
      });
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }
}