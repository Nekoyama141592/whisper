// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/counts.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final searchReplysProvider = ChangeNotifierProvider(
  (ref) => SearchReplysModel()
);

class SearchReplysModel extends ChangeNotifier {

  String reply = "";
  bool isLoading = false;
  bool isReplysMode = false;
  Map<String,dynamic> giveComment = {};
  // snapshots
  int refreshIndex = oneTimeReadCount;
  late Stream<QuerySnapshot> replysStream;
  // IP
  String ipv6 = '';

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
            TextButton(
              child: Text(
                'cancel',
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
              onPressed: () { 
                Navigator.pop(context);
              },
            ),
            RoundedButton(
              text: '送信', 
              widthRate: 0.25, 
              verticalPadding: 10.0, 
              horizontalPadding: 10.0, 
              press: () async { 
                await makeReply(currentSongMap, currentUserDoc, thisComment);
                reply = "";
                Navigator.pop(context);
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
                .where('commentId',isEqualTo: thisComment['commentId'])
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
                replysStream = FirebaseFirestore.instance
                .collection('replys')
                .where('commentId',isEqualTo: thisComment['commentId'])
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
                replysStream = FirebaseFirestore.instance
                .collection('replys')
                .where('commentId',isEqualTo: thisComment['commentId'])
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
    replysStream = FirebaseFirestore.instance
    .collection('replys')
    .where('commentId',isEqualTo: thisComment['commentId'])
    .orderBy('likesUidsCount',descending: true)
    .limit(refreshIndex)
    .snapshots();
    notifyListeners();
  }

  Future makeReply(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) async {
    final commentId = thisComment['commentId'];
    if (ipv6.isEmpty) { ipv6 =  await Ipify.ipv64(); }
    final map = makeReplyMap(commentId, currentUserDoc);
    await addReplyToFirestore(map);
    final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongMap['userDocId']);
    await updateReplyNotificationsOfPassiveUser(commentId, passiveUserDoc, currentUserDoc, thisComment);
  }

  Map<String,dynamic> makeReplyMap(String commentId,DocumentSnapshot currentUserDoc) {
    final map = {
      'commentId': commentId,
      'createdAt': Timestamp.now(),
      'ipv6': ipv6,
      'isNFTicon': false,
      'isOfficial': false,
      'likesUids': [],
      'reply': reply,
      'replyId': 'reply' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString() ,
      'score': 0,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    notifyListeners();
    return map;
  }
  
  Future addReplyToFirestore(Map<String,dynamic> map) async {
    try {
      await FirebaseFirestore.instance
      .collection('replys')
      .add(map);
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

  Future updateReplyNotificationsOfPassiveUser(String commentId,DocumentSnapshot passiveUserDoc,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) async {

    final String notificationId = 'replyNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString();
    final comment = thisComment['comment'];
    Map<String,dynamic> map = {
      'commentId': commentId,
      'comment': comment,
      'createdAt': Timestamp.now(),
      'notificationId': notificationId,
      'reply': reply,
      'uid': currentUserDoc['uid'],
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

  Future<void> like(List<dynamic> likedReplyIds,Map<String,dynamic> thisReply,DocumentSnapshot currentUserDoc,) async {
    final replyId = thisReply['replyId'];
    addReplyIdTolikedReplyIds(likedReplyIds, replyId);
    final newReplyDoc = await setNewReplyDoc(thisReply);
    await updateLikesUidsOfReply(currentUserDoc, newReplyDoc);
    await updateLikesUidsOfReply(currentUserDoc, newReplyDoc);
  }

  void addReplyIdTolikedReplyIds(List<dynamic> likedReplyIds,String replyId) {
    likedReplyIds.add(replyId);
    notifyListeners();
  } 

  Future<DocumentSnapshot> setNewReplyDoc(Map<String,dynamic> thisReply) async {
    final newReplyDoc = await FirebaseFirestore.instance
    .collection('replys')
    .doc(thisReply['objectID'],)
    .get();
    return newReplyDoc;
  }

  Future<void> updateLikesUidsOfReply(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc) async {
    List<dynamic> likesUids = newReplyDoc['likesUids'];
    int likesUidsCount = newReplyDoc['likesUidsCount'];
    final String uid = currentUserDoc['uid'];
    likesUids.add(uid);
    await FirebaseFirestore.instance
    .collection('replys')
    .doc(newReplyDoc.id)
    .update({
      'likesUids': likesUids,
      'likesUidsCount': likesUidsCount + 1,
    });
  }


  Future<void> updateLikedReplyDocsOfUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> thisReply,List<dynamic> likedReplys) async {
    try {
      final newLikedReply = {
        'likedReplyId': thisReply['replyId'],
        'createdAt': Timestamp.now(),
      };
      likedReplys.add(newLikedReply);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
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
      'likesUidsCount': likesUidsCount - 1,
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