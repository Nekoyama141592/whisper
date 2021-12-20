// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/counts.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// states
import 'package:whisper/constants/sort_states.dart';

final replysProvider = ChangeNotifierProvider(
  (ref) => ReplysModel()
);

class ReplysModel extends ChangeNotifier {

  String reply = "";
  String elementState = 'comment';
  bool isLoading = false;
  bool isReplysMode = false;
  Map<String,dynamic> giveComment = {};
  // snapshots
  int refreshIndex = oneTimeReadCount;
  late Stream<QuerySnapshot> replysStream;
  // IP
  String ipv6 = '';
  // refresh
  SortState sortState = SortState.byLikedUidsCount;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  
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

  void onAddReplyButtonPressed(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController replyEditingController,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) {
    final String commentsState = currentSongMap['commentsState'];
    final List<dynamic> followerUids = currentUserDoc['followerUids'];
    reply = '';
    switch(commentsState){
      case 'open':
      showMakeReplyDialogue(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
      break;
      case 'isLocked':
      if (currentSongMap['uid'] == currentUserDoc['uid']) {
        showMakeReplyDialogue(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('リプライは投稿主しかできません')));
      }
      break;
      case 'onlyFollowingUsers':
      if (followerUids.contains(currentSongMap['uid'])) {
        showMakeReplyDialogue(context, currentSongMap, replyEditingController, currentUserDoc, thisComment);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿主がフォローしている人しかリプライできません')));
      }
      break;
    }
  }

  void showMakeReplyDialogue(BuildContext context,Map<String,dynamic> currentSongMap,TextEditingController replyEditingController,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) {
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('reply'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  child: TextField(
                    controller: replyEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      reply = text;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            RoundedButton(
              text: '戻る', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 10.0, 
              press: () async { 
                Navigator.pop(context);
                await makeReply(currentSongMap, currentUserDoc, thisComment);
              }, 
              textColor: Theme.of(context).primaryColor, 
              buttonColor: Theme.of(context).focusColor
            ),
            RoundedButton(
              text: '送信', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 10.0, 
              press: () async { 
                Navigator.pop(context);
                await makeReply(currentSongMap, currentUserDoc, thisComment);
              }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).primaryColor
            )
          ],
        );
      }
    );
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
                .collection('replys')
                .where('elementId',isEqualTo: thisComment['commentId'])
                .orderBy('likesUidsCount',descending: true )
                .limit(refreshIndex)
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
                .collection('replys')
                .where('elementId',isEqualTo: thisComment['commentId'])
                .orderBy('createdAt',descending: true)
                .limit(refreshIndex)
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
                .collection('replys')
                .where('elementId',isEqualTo: thisComment['commentId'])
                .orderBy('createdAt',descending: false)
                .limit(refreshIndex)
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

  

  void getReplyDocs(BuildContext context,Map<String,dynamic> thisComment)  {
    isReplysMode = true;
    giveComment = thisComment;
    try {
      replysStream = FirebaseFirestore.instance
      .collection('replys')
      .where('elementId',isEqualTo: thisComment['commentId'])
      .orderBy('likesUidsCount',descending: true )
      .limit(refreshIndex)
      .snapshots();
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future onLoading(Map<String,dynamic> thisComment) async {
    refreshIndex += oneTimeReadCount;
    switch(sortState) {
      case SortState.byLikedUidsCount:
      replysStream = FirebaseFirestore.instance
      .collection('replys')
      .where('elementId',isEqualTo: thisComment['commentId'])
      .orderBy('likesUidsCount',descending: true )
      .limit(refreshIndex)
      .snapshots();
      break;
      case SortState.byNewestFirst:
      replysStream = FirebaseFirestore.instance
      .collection('replys')
      .where('elementId',isEqualTo: thisComment['commentId'])
      .orderBy('createdAt',descending: true)
      .limit(refreshIndex)
      .snapshots();
      break;
      case SortState.byOldestFirst:
      replysStream = FirebaseFirestore.instance
      .collection('replys')
      .where('elementId',isEqualTo: thisComment['commentId'])
      .orderBy('createdAt',descending: false)
      .limit(refreshIndex)
      .snapshots();
      break;
    }
    notifyListeners();
    refreshController.loadComplete();
  }

  Future makeReply(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) async {
    final elementId = thisComment['commentId'];
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final map = makeReplyMap(elementId, currentUserDoc);
    await addReplyToFirestore(map);
    // notification
    if (currentSongMap['uid'] != currentUserDoc['uid']) {
      final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap['userDocId']);
      final List<dynamic> mutesUids = passiveUserDoc['mutesUids'];
      final List<dynamic> blockingUids = passiveUserDoc['blockingUids'];
      // mutesIpv6s
      List<dynamic> mutesIpv6s = [];
      final List<dynamic> mutesIpv6AndUids = passiveUserDoc['mutesIpv6AndUids'];
      mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
        mutesIpv6s.add(mutesIpv6AndUid['ipv6']);
      });
      if ( !mutesUids.contains(currentUserDoc['uid']) && !blockingUids.contains(currentUserDoc['uid']) && !mutesIpv6s.contains(currentUserDoc['uid']) ) {
        await updateReplyNotificationsOfPassiveUser(elementId, passiveUserDoc, currentUserDoc, thisComment);
      }
    }
  }

  Map<String,dynamic> makeReplyMap(String elementId,DocumentSnapshot currentUserDoc) {
    final map = {
      'elementId': elementId,
      'elementState': elementState,
      'createdAt': Timestamp.now(),
      'ipv6': ipv6,
      'isNFTicon': currentUserDoc['isNFTicon'],
      'isOfficial': currentUserDoc['isOfficial'],
      'likesUids': [],
      'likesUidsCount': 0,
      'negativeScore': 0,
      'positiveScore': 0,
      'reply': reply,
      'replyId': 'reply' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString() ,
      'score': 10000,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    return map;
  }
  
  Future addReplyToFirestore(Map<String,dynamic> map) async {
    try {
      await FirebaseFirestore.instance
      .collection('replys')
      .doc(map['replyId'])
      .set(map);
    } catch(e) {
      print(e.toString());
    }
  }

  Future setPassiveUserDoc(String passiveUserDocId) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDocId)
    .get();
    return passiveUserDoc;
  }

  Future updateReplyNotificationsOfPassiveUser(String elementId,DocumentSnapshot passiveUserDoc,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) async {

    final String notificationId = 'replyNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString();
    final comment = thisComment['comment'];
    Map<String,dynamic> map = {
      'elementId': elementId,
      'elementState': elementState,
      'comment': comment,
      'createdAt': Timestamp.now(),
      'isNFTicon': currentUserDoc['isNFTicon'],
      'isOfficial': currentUserDoc['isOfficial'],
      'notificationId': notificationId,
      'reply': reply,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };

    List<dynamic> replyNotifications = passiveUserDoc['replyNotifications'];
    replyNotifications.add(map);
    await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDoc.id)
    .update({
      'replyNotifications': replyNotifications,
    });
  }

  Future<void> like(List<dynamic> likedReplyIds,Map<String,dynamic> thisReply,DocumentSnapshot currentUserDoc,List<dynamic> likedReplys) async {
    final replyId = thisReply['replyId'];
    likedReplyIds.add(replyId);
    notifyListeners();
    final newReplyDoc = await setNewReplyDoc(thisReply);
    await updateLikesUidsOfReply(currentUserDoc, newReplyDoc);
    await updateLikedReplysOfUser(currentUserDoc, thisReply, likedReplys);
  }

  Future<DocumentSnapshot> setNewReplyDoc(Map<String,dynamic> thisReply) async {
    DocumentSnapshot newReplyDoc = await FirebaseFirestore.instance.collection('replys').doc(thisReply['replyId']).get();
    return newReplyDoc;
  }

  Future<void> updateLikesUidsOfReply(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc) async {
    final String uid = currentUserDoc['uid'];
    List<dynamic> likesUids = newReplyDoc['likesUids'];
    int likesUidsCount = newReplyDoc['likesUidsCount'];
    likesUids.add(uid);
    notifyListeners();
    await FirebaseFirestore.instance.collection('replys').doc(newReplyDoc.id)
    .update({
      'likesUids': likesUids,
      'likesUidsCount': likesUidsCount + 1,
    });
  }


  Future<void> updateLikedReplysOfUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> thisReply,List<dynamic> likedReplys) async {
    try {
      final newLikedReply = {
        'likedReplyId': thisReply['replyId'],
        'createdAt': Timestamp.now(),
      };
      likedReplys.add(newLikedReply);
      notifyListeners();
      await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
      .update({
        'likedReplys': likedReplys,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> unlike(List<dynamic> likedReplyIds,Map<String,dynamic> thisReply,DocumentSnapshot currentUserDoc,List<dynamic> likedReplys) async {
    final replyId = thisReply['replyId'];
    removeReplyIdFromLikedReplyIds(likedReplyIds, replyId);
    final newReplyDoc = await setNewReplyDoc(thisReply);
    await removeLikesUidOfReply(currentUserDoc, newReplyDoc);
    await removeLikedReplyOfUser(currentUserDoc, newReplyDoc, likedReplys);
  }

  void removeReplyIdFromLikedReplyIds(List<dynamic> likedReplyIds,String replyId) {
    likedReplyIds.remove(replyId);
    notifyListeners();
  }

  Future removeLikesUidOfReply(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc) async {
    List<dynamic> likesUids = newReplyDoc['likesUids'];
    int likesUidsCount = newReplyDoc['likesUidsCount'];
    likesUids.remove(currentUserDoc['uid']);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('replys')
    .doc(newReplyDoc.id)
    .update({
      'likesUids': likesUids,
      'likesUidsCount': likesUidsCount -1,
    });
  }

  Future removeLikedReplyOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc,List<dynamic> likedReplys) async {
    likedReplys.removeWhere((likedReply) => likedReply['likedReplyId'] == newReplyDoc['replyId']);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'likedReplys': likedReplys,
    });
  }
  
}