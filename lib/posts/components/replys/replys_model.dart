// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final replyProvider = ChangeNotifierProvider(
  (ref) => ReplyModel()
);

class ReplyModel extends ChangeNotifier {

  String reply = "";

  Future makeReply(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) async {
    final commentId = thisComment['commentId'];
    await addReplyToFirestore(commentId, currentUserDoc);
    final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongDoc.id);
    await updateReplyNotificationsOfPassiveUser(commentId, passiveUserDoc, currentUserDoc, thisComment);
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

  Future setPassiveUserDoc(String passiveUserDocId) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDocId)
    .get();
    return passiveUserDoc;
  }

  Future addReplyToFirestore(String commentId, DocumentSnapshot currentUserDoc) async {
    try {
      await FirebaseFirestore.instance
      .collection('replys')
      .add({
        'commentId': commentId,
        'createdAt': Timestamp.now(),
        'reply': reply,
        'uid': currentUserDoc['uid'],
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['imageURL'],
      });
    } catch(e) {
      print(e.toString());
    }
  }

}