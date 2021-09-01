import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostsFeaturesModel()
);

class PostsFeaturesModel extends ChangeNotifier{
  Future like(String uid, DocumentSnapshot postDoc) async {
    try {
      await FirebaseFirestore.instance
      .collection('likes')
      .add({
        'uid': uid,
        'postId': postDoc['postId'],
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future preservate(String uid, DocumentSnapshot postDoc) async {
    try {
      await FirebaseFirestore.instance
      .collection('preservations')
      .add({
        'uid': uid,
        'postId': postDoc['postId'],
      });
    } catch(e) {
      print(e.toString());
    }
  }
}
