import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
final commentsProvider = ChangeNotifierProvider(
  (ref) => CommentsModel()
);

class CommentsModel extends ChangeNotifier {
  List<String> commentList = [];
  bool isLoading = false;
 
  
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
  }

  Future onCommentsButtonPressed(String postId) async {
    
    startLoading();
    try{
      await FirebaseFirestore.instance
      .collection('comments')
      .where('postId',isEqualTo: postId)
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          commentList.add(doc['comment']);
        });
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
    endLoading();
  }
}