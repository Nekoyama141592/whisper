// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final replyProvider = ChangeNotifierProvider(
  (ref) => ReplysModel()
);

class ReplysModel extends ChangeNotifier {

  String reply = "";


  void onAddReplyButtonPressed(BuildContext context,DocumentSnapshot currentSongDoc,TextEditingController replyEditingController,DocumentSnapshot currentUserDoc,Map<String,dynamic> thisComment) {
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
              widthRate: 0.95, 
              verticalPadding: 10.0, 
              horizontalPadding: 10.0, 
              press: () async { makeReply(currentSongDoc, currentUserDoc, thisComment); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).primaryColor
            )
          ],
        );
      }
    );
  }

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