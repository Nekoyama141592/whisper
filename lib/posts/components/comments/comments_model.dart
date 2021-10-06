// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  
  bool isLoading = false;
  bool didCommented = false;
  List<dynamic> comments = [];
  // comment
  String comment = "";
  String reply = "";
  Map<String,dynamic> postComment = {};
  
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

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
            ElevatedButton(
              child: Text('送信'),
              onPressed: () async {
                Navigator.pop(context);
                await makeComment(currentSongDoc,currentUserDoc);
              }, 
            )
          ],
        );
      }
    );
  }
  Future makeComment(DocumentSnapshot currentSongDoc,DocumentSnapshot currentUserDoc) async {
    startLoading();
    await updateCommentsOfPostWhenMakeComment(currentSongDoc,currentUserDoc);
    endLoading();
  }

  Future like(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId) async {
    // Someone left a comment on your post.
    await updateCommentsOfPostWhenSomeoneLiked(currentSongDoc, commentId,currentUserDoc);
    // I liked your post.
    await updateLikedCommentsOfCurrentUser(commentId,currentUserDoc);
  }

  Future makeReply(String passiveUserDocId,String commentId,DocumentSnapshot currentUserDoc) async {
    await addReplyToFirestore(commentId, currentUserDoc);
    // reply notification
    await setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(passiveUserDocId, commentId,currentUserDoc);
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


  Future setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(String passiveUserDocId,String commentId,DocumentSnapshot currentUserDoc) async {
    DocumentSnapshot passiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDocId)
    .get();
    await updateReplyNotificationsOfPassiveUser(commentId, passiveUserDoc,currentUserDoc);
  }

  Future updateReplyNotificationsOfPassiveUser(String commentId,DocumentSnapshot passiveUserDoc,DocumentSnapshot currentUserDoc) async {

    final String notificationId = currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString();

    Map<String,dynamic> map = {
      'commentId': commentId,
      'comment': comment,
      'createdAt': Timestamp.now(),
      'notificationId': notificationId,
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