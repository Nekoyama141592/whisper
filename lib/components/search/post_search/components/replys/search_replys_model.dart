// material
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final searchReplysProvider = ChangeNotifierProvider(
  (ref) => SearchReplysModel()
);

class SearchReplysModel extends ChangeNotifier {

  String reply = "";
  List<Map<String,dynamic>> replyMaps = [];
  bool isLoading = false;
  bool isReplysMode = false;
  Map<String,dynamic> giveComment = {};
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

  Future getReplyDocs(BuildContext context,Map<String,dynamic> thisComment) async {
    isReplysMode = true;
    startLoading();
    giveComment = thisComment;
    try{
      await FirebaseFirestore.instance
      .collection('replys')
      .get()
      .then((qshot) {
        if (qshot.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('まだリプライはありません')));
        } else {
            qshot.docs.forEach((DocumentSnapshot doc) {
              final map = doc.data() as Map<String,dynamic>;
              replyMaps.add(map);
          });
          notifyListeners();
        }
      });
    } catch(e) {
      print(e.toString());
    }
    endLoading();
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
      'likesUids': [],
      'reply': reply,
      'uid': currentUserDoc['uid'],
      'userDocId': currentUserDoc.id,
      'userName': currentUserDoc['userName'],
      'userImageURL': currentUserDoc['imageURL'],
    };
    replyMaps.add(map);
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

  Future<void> like(Map<String,dynamic> thisReply,DocumentSnapshot currentUserDoc,) async {
    final newReplyDoc = await setNewReplyDoc(thisReply);
    await updateLikesUidsOfReply(currentUserDoc, newReplyDoc);
    await updateLikesUidsOfReply(currentUserDoc, newReplyDoc);
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
    final String uid = currentUserDoc['uid'];
    likesUids.add(uid);
    await FirebaseFirestore.instance
    .collection('replys')
    .doc(newReplyDoc.id)
    .update({
      'likesUids': likesUids,
    });
  }


  Future<void> updateLikedReplyDocsOfUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> thisReply,List<dynamic> likedReplys) async {
    try {
      final newLikedReply = {
        'likedReplyDocId': thisReply['objectID'],
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

  Future<void> unlike(Map<String,dynamic> thisReply,DocumentSnapshot currentUserDoc,List<dynamic> likedReplys) async {
    final newReplyDoc = await setNewReplyDoc(thisReply);
    await removeLikesUidOfReply(currentUserDoc, newReplyDoc);
    await removeLikedReplyOfUser(currentUserDoc, newReplyDoc, likedReplys);
  }

  Future removeLikesUidOfReply(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc) async {
    List<dynamic> likesUids = newReplyDoc['likesUids'];
    likesUids.remove(currentUserDoc['uid']);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('replys')
    .doc(newReplyDoc.id)
    .update({
      'likesUids': likesUids,
    });
  }

  Future removeLikedReplyOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot newReplyDoc,List<dynamic> likedReplys) async {
    likedReplys.removeWhere((likedReply) => likedReply['likedReplyDocId'] == newReplyDoc.id);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'likedReplys': likedReplys,
    });
  }

}