import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostsFeaturesModel()
);

class PostsFeaturesModel extends ChangeNotifier{
  
  String comment = '';

  Future like(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await updateLikesOfPost(currentUserDoc, postDoc);
    await updateLikesOfUser(currentUserDoc, postDoc);
  }

  Future preservate(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await updatePreservationsOfPost(currentUserDoc, postDoc);
    await updatePreservationsOfUser(currentUserDoc, postDoc);
  }

  Future updateLikesOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      
      final List likes = postDoc['likes'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      likes.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(postDoc.id)
      .update({
        'likes': likes,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future updateLikesOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List likes = currentUserDoc['likes'];
      final Map<String, dynamic> map = {
        'postId': postDoc.id,
        'createdAt': Timestamp.now(),
      };
      likes.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'likes': likes,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updatePreservationsOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      // User ver
      final List preservations = postDoc['preservations'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      preservations.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(postDoc.id)
      .update({
        'preservations': preservations,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future updatePreservationsOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List preservations = currentUserDoc['preservations'];
      final Map<String, dynamic> map = {
        'postId': postDoc.id,
        'createdAt': Timestamp.now(),
      };
      preservations.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'preservations': preservations,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  Future makeComment(BuildContext context, String uid, DocumentSnapshot postDoc) async {
    if (comment.isEmpty) {
      throw('入力してください');
    } else {
      try{
        FirebaseFirestore.instance
        .collection('comments')
        .add({
          'uid': uid,
          'postId': postDoc['postId'],
          'comment': comment,
        }).then((_) {
          Navigator.pop(context);
        });
      } catch(e) {

      }
    }
  }

  void reload() {
    notifyListeners();
  }
}
