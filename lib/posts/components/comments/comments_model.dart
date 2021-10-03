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

  Map<String,dynamic> thisComment = {};
  
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

  Future makeComment(String postDocId,List<dynamic> postComments,String passiveUid,String commentId) async {
    startLoading();
    setCurrentUser();
    await updateCommentsOfPostWhenMakeComment(postDocId, postComments);
    // await setPassiveUserDoc(passiveUid, commentId);
    endLoading();
  }

  Future like(List<dynamic> postComments,String commentId,String postDocId,List<dynamic> likedComments, DocumentSnapshot currentUserDoc) async {
    startLoading();
    setCurrentUser();
    // Someone left a comment on your post.
    await updateCommentsOfPostWhenSomeoneLiked(postComments, commentId, postDocId);
    // I liked your post.
    await updateLikedCommentsOfUser(commentId,likedComments,currentUserDoc);
    // make notification
    await updateIsLikedNotificationsOfUser(currentUserDoc);
    endLoading();
  }

  Future updateCommentsOfPostWhenMakeComment(String postDocId,List<dynamic> postComments) async {
    
    try{
      final commentMap = {
        'comment': comment,
        'uid': currentUser!.uid,
        'createdAt': Timestamp.now(),
        'likes': [{}],
        'commentId': currentUser!.uid + DateTime.now().microsecondsSinceEpoch.toString() ,
      };
      postComments.add(commentMap);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(postDocId)
      .update({
        'comments': postComments,
      });
    } catch(e) {
      print(e.toString());
    }
    endLoading();
  }

  

  Future updateCommentsOfPostWhenSomeoneLiked(List<dynamic> postComments,String commentId,String postDocId) async {
    //Likeが押された時のPost側の処理
    try{
      postComments.forEach((postComment) {
        if (postComment['commentId'] == commentId){
          thisComment = postComment;
          List<dynamic> likes = thisComment['likes'];
          final Map<String,dynamic> newLikeMap = {
            'uid': currentUser!.uid,
            'createdAt': Timestamp.now(),
          };
          likes.add(newLikeMap);
          thisComment['likes'] = likes;
          postComments.add(thisComment);
          FirebaseFirestore.instance
          .collection('posts')
          .doc(postDocId)
          .update({
            'comments': postComments,
          });
        }
      });
    } catch(e) {
      print(e.toString());
    }
  }
  Future updateLikedCommentsOfUser(String commentId,List<dynamic> likedComments,DocumentSnapshot currentUserDoc) async {
    // User側の処理
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

  Future setPassiveUserDoc(String passiveUid,String commentId) async {
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