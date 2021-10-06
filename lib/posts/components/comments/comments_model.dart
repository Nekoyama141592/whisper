// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  

  bool didCommented = false;
  List<dynamic> comments = [];
  // comment
  String comment = "";
  Map<String,dynamic> postComment = {};

  void reload() {
    notifyListeners();
  }

  void onFloatingActionButtonPressed(BuildContext context,DocumentSnapshot currentSongDoc,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
    showDialog(
      context: context, 
      builder: (_) {
        return AlertDialog(
          title: Text('comment'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Container(
                  child: TextField(
                    controller: commentEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      comment = text;
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
              press: () async { makeComment(currentSongDoc, currentUserDoc); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).primaryColor
            )
          ],
        );
      }
    );
  }
  Future makeComment(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc) async {
    await updateCommentsOfPostWhenMakeComment(currentSongDoc,currentUserDoc);
    final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongDoc['userDocId']);
    await updateCommentNotificationsOfPassiveUser(currentSongDoc, currentUserDoc,passiveUserDoc);
  }

  Future like(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId) async {
    await updateCommentsOfPostWhenSomeoneLiked(currentSongDoc, commentId,currentUserDoc);
    await updateLikedCommentsOfCurrentUser(commentId,currentUserDoc);
  }

  Future updateCommentNotificationsOfPassiveUser(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      List<dynamic> commentNotifications = passiveUserDoc['commentNotifications'];
      final Map<String,dynamic> newCommentNotificationMap = {
        'comment': comment,
        'createdAt': Timestamp.now(),
        'postId': 'commentNotification' + currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'postTitle': currentSongDoc['title'],
        'uid': currentUserDoc['uid'],
        'userDocId': currentUserDoc.id,
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['userImageURL'],
      };
      commentNotifications.add(newCommentNotificationMap);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(passiveUserDoc.id)
      .update({
        'commentNotifications': commentNotifications,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updateCommentsOfPostWhenMakeComment(DocumentSnapshot currentSongDoc, DocumentSnapshot currentUserDoc) async {
    try{
      final commentMap = {
        'comment': comment,
        'commentId': currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString(),
        'createdAt': Timestamp.now(),
        'likesUids': [],
        'uid': currentUserDoc['uid'],
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['imageURL'],
      };
      if (!didCommented) {
        comments = currentSongDoc['comments'];
      }
      comments.add(commentMap);
      print(comments.length.toString());
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'comments': comments,
      });
      didCommented = true;
    } catch(e) {
      print(e.toString());
    }
  }

  

  Future updateCommentsOfPostWhenSomeoneLiked(DocumentSnapshot currentSongDoc,String commentId,DocumentSnapshot currentUserDoc) async {

    final List<dynamic> postComments = currentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      postComments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likesUids'];
          likesUids.add(currentUserDoc['uid']);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(currentSongDoc.id)
          .update({
            'comments': postComments,
          });
        }
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updateLikedCommentsOfCurrentUser(String commentId,DocumentSnapshot currentUserDoc) async {
    // User側の処理
    List<dynamic> likedComments = currentUserDoc['likedComments'];
    Map<String,dynamic> map = {
      'commentId': commentId,
      'createdAt': Timestamp.now(),
    };

    likedComments.add(map);
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'likedComments': likedComments,
    });

  }


  Future setPassiveUserDoc(String passiveUserDocId) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDocId)
    .get();
    return passiveUserDoc;
  }

  
}