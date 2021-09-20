import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future onCommentsButtonPressed(String postDocId,List<dynamic> postComments) async {
    
    startLoading();
    setCurrentUser();
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

  Future like(List<dynamic> postComments,String commentId,String postDocId) async {
    startLoading();
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
    endLoading();
  }
}