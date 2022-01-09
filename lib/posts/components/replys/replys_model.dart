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
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// states
import 'package:whisper/constants/enums.dart';
// model
import 'package:whisper/main_model.dart';

final replysProvider = ChangeNotifierProvider(
  (ref) => ReplysModel()
);

class ReplysModel extends ChangeNotifier {

  String reply = "";
  String elementState = commentKey;
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

  void onAddReplyButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController replyEditingController,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> thisComment) {
    // コメントの投稿主が自分の場合
    // このPostの投稿主が自分の場合
    // このPostの投稿主とコメントの投稿主が一致している場合
    if (thisComment[uidKey] == currentUserDoc[uidKey] || currentSongMap[uidKey] == currentUserDoc[uidKey] || thisComment[uidKey] == currentSongMap[uidKey]) {
      showMakeReplyInputFlashBar(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたはこのコメントに返信できません')));
    }
  }

  void showMakeReplyInputFlashBar(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController replyEditingController,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> thisComment) {
    final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send = (context, controller, _) {
      return IconButton(
        onPressed: () async {
          if (reply.isEmpty) {
            controller.dismiss();
          } else {
            await makeReply(currentSongMap, currentUserDoc, thisComment);
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
                .collection(replysKey)
                .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
                .orderBy(likeCountKey,descending: true )
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
                .collection(replysKey)
                .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
                .orderBy(createdAtKey,descending: true)
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
                .collection(replysKey)
                .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
                .orderBy(createdAtKey,descending: false)
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

  

  void getReplysStream({ required BuildContext context, required Map<String,dynamic> thisComment, required ReplysModel replysModel, required Map<String,dynamic> currentSongMap, required MainModel mainModel })  {
    refreshController = RefreshController(initialRefresh: false);
    routes.toReplysPage(context: context, replysModel: replysModel, currentSongMap: currentSongMap, thisComment: thisComment, mainModel: mainModel);
    giveComment = thisComment;
    final String commentId = thisComment[commentIdKey];
    try {
      if (indexCommentId != commentId) {
        indexCommentId = commentId;
        replysStream = FirebaseFirestore.instance.collection(replysKey).where(elementIdKey,isEqualTo: thisComment[commentIdKey]).orderBy(createdAtKey,descending: true).limit(limitIndex).snapshots();
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future onLoading(Map<String,dynamic> thisComment) async {
    limitIndex += oneTimeReadCount;
    switch(sortState) {
      case SortState.byLikedUidCount:
      replysStream = FirebaseFirestore.instance
      .collection(replysKey)
      .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
      .orderBy(likeCountKey,descending: true )
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byNewestFirst:
      replysStream = FirebaseFirestore.instance
      .collection(replysKey)
      .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
      .orderBy(createdAtKey,descending: true)
      .limit(limitIndex)
      .snapshots();
      break;
      case SortState.byOldestFirst:
      replysStream = FirebaseFirestore.instance
      .collection(replysKey)
      .where(elementIdKey,isEqualTo: thisComment[commentIdKey])
      .orderBy(createdAtKey,descending: false)
      .limit(limitIndex)
      .snapshots();
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }

  Future makeReply(Map<String,dynamic> currentSongMap,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> thisComment) async {
    final elementId = thisComment[commentIdKey];
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final newReplyMap = makeReplyMap(elementId, currentUserDoc,currentSongMap);
    await addReplyToFirestore(newReplyMap);
    // notification
    if (currentSongMap[uidKey] != currentUserDoc[uidKey]) {
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
      if ( isDisplayUid(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s ,uid: currentUserDoc[uidKey], ipv6: ipv6) ) {
        await updateReplyNotificationsOfPassiveUser(elementId: elementId, passiveUserDoc: passiveUserDoc, currentUserDoc: currentUserDoc, thisComment: thisComment, newReplyMap: newReplyMap);
      }
    }
  }

  Map<String,dynamic> makeReplyMap(String elementId,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> currentSongMap) {
    final newReplyMap = {
      elementIdKey: elementId,
      elementStateKey: elementState,
      createdAtKey: Timestamp.now(),
      followerCountKey: currentUserDoc[followerCountKey],
      ipv6Key: ipv6,
      isDeleteKey: false,
      isNFTiconKey: currentUserDoc[isNFTiconKey],
      isOfficialKey: currentUserDoc[isOfficialKey],
      likeCountKey: 0,
      negativeScoreKey: 0,
      passiveUidKey: currentSongMap[uidKey],
      postIdKey: currentSongMap[postIdKey],
      positiveScoreKey: 0,
      replyKey: reply,
      replyIdKey: replyKey + currentUserDoc[uidKey] + DateTime.now().microsecondsSinceEpoch.toString() ,
      scoreKey: defaultScore,
      subUserNameKey: currentUserDoc[subUserNameKey],
      uidKey: currentUserDoc[uidKey],
      userNameKey: currentUserDoc[userNameKey],
      userImageURLKey: currentUserDoc[imageURLKey],
    };
    return newReplyMap;
  }
  
  Future addReplyToFirestore(Map<String,dynamic> map) async {
    try {
      await FirebaseFirestore.instance.collection(replysKey).doc(map[replyIdKey]).set(map);
    } catch(e) {
      print(e.toString());
    }
  }

  Future setPassiveUserDoc(Map<String,dynamic> currentSongMap) async {
    final DocumentSnapshot<Map<String,dynamic>> passiveUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentSongMap[uidKey]).get();
    return passiveUserDoc;
  }

  Future updateReplyNotificationsOfPassiveUser({ required String elementId, required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc, required Map<String,dynamic> thisComment, required Map<String,dynamic> newReplyMap }) async {

    final String notificationId = 'replyNotification' + currentUserDoc[uidKey] + DateTime.now().microsecondsSinceEpoch.toString();
    final comment = thisComment[commentKey];
    Map<String,dynamic> map = {
      commentKey: comment,
      createdAtKey: Timestamp.now(),
      elementIdKey: elementId,
      elementStateKey: elementState,
      followerCountKey: currentUserDoc[followerCountKey],
      isDeleteKey: false,
      isNFTiconKey: currentUserDoc[isNFTiconKey],
      isOfficialKey: currentUserDoc[isOfficialKey],
      notificationIdKey: notificationId,
      passiveUidKey: passiveUserDoc[uidKey],
      postIdKey: thisComment[postIdKey],
      replyKey: reply,
      replyScoreKey: newReplyMap[scoreKey],
      replyIdKey: newReplyMap[replyIdKey],
      subUserNameKey: currentUserDoc[subUserNameKey],
      uidKey: currentUserDoc[uidKey],
      userNameKey: currentUserDoc[userNameKey],
      userImageURLKey: currentUserDoc[imageURLKey],
    };
    await replyNotificationRef(passiveUid: thisComment[uidKey], notificationId: notificationId).set(map);
  }

  Future<void> like(List<dynamic> likedReplyIds,Map<String,dynamic> thisReply,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,List<dynamic> likedReplys) async {
    // process UI
    final replyId = thisReply[replyIdKey];
    likedReplyIds.add(replyId);
    notifyListeners();
    // backend
    await addLikeSubCol(thisReply: thisReply, currentUserDoc: currentUserDoc);
    await updateLikedReplysOfUser(currentUserDoc, thisReply, likedReplys);
  }

  Future<void> addLikeSubCol({ required Map<String,dynamic> thisReply,required DocumentSnapshot<Map<String,dynamic>> currentUserDoc}) async {
    await likeChildRef(parentColKey: replysKey, uniqueId: thisReply[replyIdKey], activeUid: currentUserDoc.id).set({
      uidKey: currentUserDoc.id,
      createdAtKey: Timestamp.now(),
    });
  }


  Future<void> updateLikedReplysOfUser(DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> thisReply,List<dynamic> likedReplys) async {
    try {
      final newLikedReply = {
        likedReplyIdKey: thisReply[replyIdKey],
        createdAtKey: Timestamp.now(),
      };
      likedReplys.add(newLikedReply);
      await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id)
      .update({
        likedReplysKey: likedReplys,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> unlike(List<dynamic> likedReplyIds,Map<String,dynamic> thisReply,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,List<dynamic> likedReplys) async {
    final replyId = thisReply[replyIdKey];
    // processUI
    likedReplyIds.remove(replyId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(thisReply: thisReply, currentUserDoc: currentUserDoc);
    await removeLikedReplyOfUser(currentUserDoc: currentUserDoc, likedReplys: likedReplys, thisReply: thisReply);
  }

  Future<void> deleteLikeSubCol({ required Map<String,dynamic> thisReply,required DocumentSnapshot<Map<String,dynamic>> currentUserDoc}) async {
    await likeChildRef(parentColKey: replysKey, uniqueId: thisReply[replyIdKey], activeUid: currentUserDoc.id).delete();
  }

  Future removeLikedReplyOfUser({ required DocumentSnapshot<Map<String,dynamic>> currentUserDoc, required List<dynamic> likedReplys, required Map<String,dynamic> thisReply }) async {
    likedReplys.removeWhere((likedReply) => likedReply[likedReplyIdKey] == thisReply[replyIdKey]);
    await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id)
    .update({
      likedReplysKey: likedReplys,
    });
  }
  
}