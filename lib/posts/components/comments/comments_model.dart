// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  
  bool isLoading = false;
  List<dynamic> comments = [];
  User? currentUser;
  // comment
  String comment = "";
  String reply = "";
  bool isMaking = false;
  Map<String,dynamic> postComment = {};
  
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void startMaking() {
    isMaking = true;
    notifyListeners();
  }

  void endMaking() {
    isMaking = false;
    notifyListeners();
  }

  void setCurrentUser(){
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void onFloatingActionButtonPressed(BuildContext context,DocumentSnapshot currentSongDoc,TextEditingController commentEditingController,DocumentSnapshot currentUserDoc) {
    startMaking();
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
                endMaking();
              },
            ),
            ElevatedButton(
              child: Text('送信'),
              onPressed: ()async {
                await makeComment(currentSongDoc,currentUserDoc);
                endMaking();
              }, 
            )
          ],
        );
      }
    );
  }
  Future makeComment(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc) async {
    startLoading();
    setCurrentUser();
    await updateCommentsOfPostWhenMakeComment(currentSongDoc,currentUserDoc);
    endLoading();
  }

  Future like(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId) async {
    startLoading();
    setCurrentUser();
    // Someone left a comment on your post.
    await updateCommentsOfPostWhenSomeoneLiked(currentSongDoc, commentId);
    // I liked your post.
    await updateLikedCommentsOfCurrentUser(commentId,currentUserDoc);
    endLoading();
  }

  Future makeReply(String passiveUserDocId,String commentId,DocumentSnapshot currentUserDoc) async {
    await addReplyToFirestore(commentId, currentUserDoc);
    // reply notification
    await setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(passiveUserDocId, commentId);
  }

  Future updateCommentsOfPostWhenMakeComment(DocumentSnapshot currentSongDoc, DocumentSnapshot currentUserDoc) async {
    try{
      final commentMap = {
        'comment': comment,
        'createdAt': Timestamp.now(),
        'commentId': currentUser!.uid + DateTime.now().microsecondsSinceEpoch.toString(),
        'likes': [],
        'uid': currentUser!.uid,
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['imageURL'],
      };
      comments.add(commentMap);
      notifyListeners();
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'comments': comments,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  

  Future updateCommentsOfPostWhenSomeoneLiked(DocumentSnapshot currentSongDoc,String commentId) async {

    final List<dynamic> postComments = currentSongDoc['comments'];
    //Likeが押された時のPost側の処理
    try{
      postComments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          // likesUids
          List<dynamic> likesUids = postComment['likes'];
          likesUids.add(currentUser!.uid);
          postComment['likesUids'] = likesUids;
          postComments.add(postComment);
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


  Future setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(String passiveUserDocId,String commentId) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDocId)
    .get();
    await updateReplyNotificationsOfPassiveUser(commentId, passiveUserDoc);
  }

  Future updateReplyNotificationsOfPassiveUser(String commentId,DocumentSnapshot passiveUserDoc) async {

    final String notificationId = currentUser!.uid + DateTime.now().microsecondsSinceEpoch.toString();

    Map<String,dynamic> map = {
      'commentId': commentId,
      'comment': comment,
      'createdAt': Timestamp.now(),
      'notificationId': notificationId,
      'uid': currentUser!.uid,
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

  Future addReplyToFirestore(String commentId, DocumentSnapshot currentUserDoc) async {
    try {
      await FirebaseFirestore.instance
      .collection('replys')
      .add({
        'commentId': commentId,
        'createdAt': Timestamp.now(),
        'reply': reply,
        'userName': currentUserDoc['userName'],
        'userImageURL': currentUserDoc['imageURL'],
      });
    } catch(e) {
      print(e.toString());
    }
  }

}