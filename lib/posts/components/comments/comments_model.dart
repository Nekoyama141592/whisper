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
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
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

  Future<void> init(BuildContext context,AudioPlayer audioPlayer,ValueNotifier<Map<String,dynamic>> currentSongMapNotifier,MainModel mainModel,String postId) async {
    refreshController = RefreshController(initialRefresh: false);
    routes.toCommentsPage(context, audioPlayer, currentSongMapNotifier, mainModel);
    if (indexPostId != postId) {
      indexPostId = postId;
      await getCommentDocs(postId);
    }
  }

  Future<void> getCommentDocs(String postId) async {
    commentDocs = [];
    await FirebaseFirestore.instance.collection(commentsKey).where(postIdKey,isEqualTo: postId).orderBy(createdAtKey,descending: true).limit(oneTimeReadCount).get().then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
    });
    notifyListeners();
  }

  void onFloatingActionButtonPressed({ required BuildContext context, required Map<String,dynamic> currentSongMap, required TextEditingController commentEditingController, required AudioPlayer audioPlayer, required MainModel mainModel }) {
    final whisperPost = fromMapToPost(postMap: currentSongMap);
    final String commentsState = whisperPost.commentsState;
    audioPlayer.pause();
    switch(commentsState){
      case 'open':
      showMakeCommentInputFlashBar(context: context, currentSongMap: currentSongMap, commentEditingController: commentEditingController, mainModel: mainModel);
      break;
      case 'isLocked':
      if (whisperPost.uid == mainModel.currentWhisperUser.uid ) {
        showMakeCommentInputFlashBar(context: context, currentSongMap: currentSongMap, commentEditingController: commentEditingController, mainModel: mainModel);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('コメントは投稿主しかできません')));
      }
      break;
    }
  }

  void showMakeCommentInputFlashBar({ required BuildContext context, required Map<String,dynamic> currentSongMap, required TextEditingController commentEditingController, required MainModel mainModel }) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (commentEditingController.text.isEmpty) {
            controller.dismiss();
          } else {
            await makeComment(context: context, currentSongMap: currentSongMap, mainModel: mainModel);
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

  
  Future<void> makeComment({ required BuildContext context, required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final commentMap = makeCommentMap(mainModel: mainModel, currentSongMap: currentSongMap);
    final whisperComment = fromMapToWhisperComment(commentMap: commentMap);
    await FirebaseFirestore.instance.collection(commentsKey).doc(whisperComment.commentId).set(commentMap);
    // notification
    if (currentSongMap[uidKey] != mainModel.currentWhisperUser.uid ) {
      final DocumentSnapshot<Map<String,dynamic>> passiveUserDoc = await setPassiveUserDoc(currentSongMap);
      // blocks
      List<dynamic> blocksIpv6s = [];
      List<dynamic> blocksUids = [];
      final List<dynamic> blocksIpv6AndUids = passiveUserDoc[blocksIpv6AndUidsKey];
      blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
        blocksIpv6s.add(blocksIpv6AndUid[ipv6Key]);
        blocksUids.add(blocksIpv6AndUid[uidKey]);
      });
      // mutes
      List<dynamic> mutesUids = [];
      List<dynamic> mutesIpv6s = [];
      final List<dynamic> mutesIpv6AndUids = passiveUserDoc[mutesIpv6AndUidsKey];
      mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
        mutesIpv6s.add(mutesIpv6AndUid[ipv6Key]);
        mutesUids.add(mutesIpv6AndUid[uidKey]);
      });
      if ( isDisplayUid(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: mainModel.currentWhisperUser.uid, ipv6: ipv6) ) {
        await makeCommentNotification(currentSongMap: currentSongMap, mainModel: mainModel, passiveUserDoc: passiveUserDoc, newCommentMap: commentMap);
      }
    }
  }


  Map<String,dynamic> makeCommentMap({ required MainModel mainModel, required Map<String,dynamic> currentSongMap}) {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final whisperPost = fromMapToPost(postMap: currentSongMap);
    final commentMap = {
      commentKey: comment,
      commentIdKey: commentKey + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString(),
      createdAtKey: Timestamp.now(),
      followerCountKey: mainModel.currentWhisperUser.followerCount,
      ipv6Key: ipv6,
      isDeleteKey: false,
      isNFTiconKey: currentWhisperUser.isNFTicon,
      isOfficialKey: currentWhisperUser.isOfficial,
      likeCountKey: 0,
      negativeScoreKey: 0,
      passiveUidKey: whisperPost.uid,
      positiveScoreKey: 0,
      postIdKey: whisperPost.postId,
      replyCountKey: 0,
      scoreKey: defaultScore,
      subUserNameKey: currentWhisperUser.subUserName,
      uidKey: currentWhisperUser.uid,
      userNameKey: currentWhisperUser.userName,
      userImageURLKey: currentWhisperUser.imageURL
    };
    return commentMap;
  }

  Future<void> makeCommentNotification({ required Map<String,dynamic> currentSongMap, required MainModel mainModel, required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc, required Map<String,dynamic> newCommentMap}) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    try{
      final Map<String,dynamic> map = {
        commentKey: newCommentMap[commentKey],
        commentScoreKey: newCommentMap[scoreKey],
        commentIdKey: newCommentMap[commentIdKey],
        createdAtKey: Timestamp.now(),
        followerCountKey: mainModel.currentWhisperUser.followerCount,
        isDeleteKey: false,
        isNFTiconKey: currentWhisperUser.isNFTicon,
        isOfficialKey: currentWhisperUser.isOfficial,
        notificationIdKey: 'commentNotification' + currentWhisperUser.uid + DateTime.now().microsecondsSinceEpoch.toString(),
        passiveUidKey: currentSongMap[uidKey],
        postTitleKey: currentSongMap[titleKey],
        postIdKey: currentSongMap[postIdKey],
        subUserNameKey: currentWhisperUser.subUserName,
        uidKey: currentWhisperUser.uid,
        userNameKey: currentWhisperUser.userName,
        userImageURLKey: currentWhisperUser.imageURL
      };
      await commentNotificationRef(passiveUid: currentSongMap[uidKey], notificationId: map[notificationIdKey]).set(map);
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future<void> like({ required Map<String,dynamic> thisComment, required MainModel mainModel}) async {
    final commentId = thisComment[commentIdKey];
    // processUi
    final likeCommentIds = mainModel.likeCommentIds;
    likeCommentIds.add(commentId);
    notifyListeners();
    await addLikeSubCol(thisComment: thisComment, mainModel: mainModel);
    await updateLikedCommentsOfUser(commentId: commentId, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required Map<String,dynamic> thisComment,required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    await likeChildRef(parentColKey: commentsKey, uniqueId: thisComment[commentIdKey] , activeUid: currentWhisperUser.uid ).set({
      uidKey: currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }

  Future<void> updateLikedCommentsOfUser({ required String commentId, required MainModel mainModel }) async {
    // User側の処理
    final likeComments = mainModel.userMeta.likeComments;
    final Map<String,dynamic> map = {
      commentIdKey: commentId,
      createdAtKey: Timestamp.now(),
    };
    likeComments.add(map);
    await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid)
    .update({
      likeCommentsKey: likeComments,
    });
  }

  Future<void> unlike({ required Map<String,dynamic> thisComment, required MainModel mainModel}) async {
    // process UI
    final commentId = thisComment[commentIdKey];
    final likeCommentIds = mainModel.likeCommentIds;
    final likeComments = mainModel.likeComments;
    likeCommentIds.remove(commentId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(thisComment: thisComment, mainModel: mainModel);
    await removeLikedCommentsFromCurrentUser(commentId: commentId, likeComments: likeComments);
  }

  Future<void> deleteLikeSubCol({ required Map<String,dynamic> thisComment,required MainModel mainModel }) async {
    await likeChildRef(parentColKey: commentsKey, uniqueId: thisComment[commentIdKey] , activeUid: mainModel.currentWhisperUser.uid ).delete();
  }

  Future<void> removeLikedCommentsFromCurrentUser({ required String commentId, required List<dynamic> likeComments}) async {
    likeComments.removeWhere((likeComment) => likeComment[commentIdKey] == commentId);
    await FirebaseFirestore.instance.collection(commentsKey).doc(commentId).update({
      likeCommentsKey: likeComments,
    });
  }

  Future<DocumentSnapshot<Map<String,dynamic>>> setPassiveUserDoc(Map<String,dynamic> currentSongMap) async {
    DocumentSnapshot<Map<String,dynamic>> passiveUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentSongMap[uidKey]).get();
    return passiveUserDoc;
  }

  Future<void> updateCommentsOfPostWhenDelete(DocumentSnapshot<Map<String,dynamic>> newCurrentSongDoc,Map<String,dynamic> comment,String postDocId) async {
    final List<dynamic> newComments = newCurrentSongDoc[commentsKey];
    newComments.remove(comment);
    await FirebaseFirestore.instance.collection(postsKey).doc(postDocId)
    .update({
      commentsKey: newComments,
    });
    
  }

  void showSortDialogue(BuildContext context,Map<String,dynamic> currentSongMap) {
    showCupertinoDialog(
      context: context, 
      builder: (context) {
        final postId = currentSongMap[postIdKey];
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
                .collection(commentsKey)
                .where(postIdKey,isEqualTo: postId)
                .orderBy(likeCountKey,descending: true )
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
                .collection(commentsKey)
                .where(postIdKey,isEqualTo: postId)
                .orderBy(createdAtKey,descending: true)
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
                .collection(commentsKey)
                .where(postIdKey,isEqualTo: postId)
                .orderBy(createdAtKey,descending: false)
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

  Future<void> onRefresh(BuildContext context,Map<String,dynamic> currentSongMap) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      break;
      case SortState.byNewestFirst:
      QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
      .collection(commentsKey)
      .where(postIdKey,isEqualTo: currentSongMap[postIdKey])
      .orderBy(createdAtKey,descending: true)
      .endBeforeDocument(commentDocs[0])
      .limit(oneTimeReadCount)
      .get();
      // Sort by oldest first
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
      docs.sort((a,b) => a[createdAtKey].compareTo(b[createdAtKey]));
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

  Future<void> onLoading(Map<String,dynamic> currentSongMap) async {
    switch(sortState) {
      case SortState.byLikedUidCount:
      await FirebaseFirestore.instance
      .collection(commentsKey)
      .where(postIdKey,isEqualTo: currentSongMap[postIdKey])
      .orderBy(likeCountKey,descending: true )
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
      .collection(commentsKey)
      .where(postIdKey,isEqualTo: currentSongMap[postIdKey])
      .orderBy(createdAtKey,descending: true)
      .startAfterDocument(commentDocs.last)
      .limit(oneTimeReadCount)
      .get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { commentDocs.add(doc); });
      });
      break;
      case SortState.byOldestFirst:
      await FirebaseFirestore.instance
      .collection(commentsKey)
      .where(postIdKey,isEqualTo: currentSongMap[postIdKey])
      .orderBy(createdAtKey,descending: false)
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