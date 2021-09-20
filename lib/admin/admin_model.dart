import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {
  
  Future addCommentToPost() async {
   
    try{
      final String num = Random().nextDouble().toString();
      WriteBatch batch = FirebaseFirestore.instance.batch();
      Map<String,dynamic> likeMap = {
        'uid': '',
        'createdAt': Timestamp.now(),
      };
      List likes = [likeMap];
      Map<String, dynamic> commentMap = {
        'uid': '',
        'createdAt': Timestamp.now(),
        'likes': likes,
        'comment': '',
        'commentId': num,
      };
      final List comments = [commentMap];
      return FirebaseFirestore.instance.collection('posts')
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          batch.update(
            doc.reference, 
            {
              'comments': comments,
            }
          );
        });
        return batch.commit();
      });
    } catch(e) {
      print(e.toString());
    }
  }
}