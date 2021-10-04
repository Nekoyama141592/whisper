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
  String comment = "";
  User? currentUser;

  Map<String,dynamic> postComment = {};
  
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
  }

  void setCurrentUser(){
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future makeComment(DocumentSnapshot currentSongDoc) async {
    startLoading();
    setCurrentUser();
    await updateCommentsOfPostWhenMakeComment(currentSongDoc);
    endLoading();
  }

  Future like(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,String commentId) async {
    startLoading();
    setCurrentUser();
    // Someone left a comment on your post.
    await updateCommentsOfPostWhenSomeoneLiked(currentSongDoc, commentId);
    // I liked your post.
    await updateLikedCommentsOfCurrentUser(commentId,currentUserDoc);
    // make notification
    await updateIsLikedNotificationsOfUser(currentUserDoc);
    endLoading();
  }

  Future reply(String passiveUid,String commentId) async {
    await setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(passiveUid, commentId);
  }

  Future updateCommentsOfPostWhenMakeComment(DocumentSnapshot currentSongDoc) async {
    try{
      final postComments = currentSongDoc['comments'];
      final commentMap = {
        'comment': comment,
        'uid': currentUser!.uid,
        'createdAt': Timestamp.now(),
        'likes': [],
        'commentId': currentUser!.uid + DateTime.now().microsecondsSinceEpoch.toString() ,
      };
      postComments.add(commentMap);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'comments': postComments,
      });
    } catch(e) {
      print(e.toString());
    }
    endLoading();
  }

  

  Future updateCommentsOfPostWhenSomeoneLiked(DocumentSnapshot currentSongDoc,String commentId) async {

    final postComments = currentSongDoc['comments'];
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

  Future updateIsLikedNotificationsOfUser(DocumentSnapshot currentUserDoc) async {
    Map<String,dynamic> map = {
      'createdAt': Timestamp.now(),
      'isRead': false,
      'uid': currentUser!.uid
    };
    List<dynamic> isLikedNotifications = currentUserDoc['isLikedNotifications'];
    isLikedNotifications.add(map);
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'isLikedNotifications': isLikedNotifications,
    });
  }

  Future setPassiveUserDocAndUpdateReplyNotificationOfPassiveUser(String passiveUid,String commentId) async {
    await FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: passiveUid)
    .limit(1)
    .get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot doc) async {
        DocumentSnapshot passiveUserDoc = doc;
        await updateReplyNotificationsOfPassiveUser(commentId, passiveUserDoc);
      });
    } );
  }

  Future updateReplyNotificationsOfPassiveUser(String commentId,DocumentSnapshot passiveUserDoc) async {
    Map<String,dynamic> map = {
      'commentId': commentId,
      'comment': comment,
      'createdAt': Timestamp.now(),
      'isRead': false,
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
}