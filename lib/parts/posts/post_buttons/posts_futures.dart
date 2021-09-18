import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostsFeaturesModel()
);

class PostsFeaturesModel extends ChangeNotifier{
  
  String comment = '';

  late DocumentSnapshot owner;
  
  Future like(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await updateLikesOfPost(currentUserDoc, postDoc);
    await updateLikesOfUser(currentUserDoc, postDoc);
    await findOwner(postDoc);
    await updateLikeNotificationsOfUser(currentUserDoc, postDoc);
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

  Future findOwner(DocumentSnapshot postDoc) async {
    FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: postDoc['uid'])
    .get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot doc) {
        owner = doc;
      });
    });
  }

  Future updateLikeNotificationsOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      List list = owner['likeNotifications'];
      
      Map<String,dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
        'isRead': false,
      };
      list.add(map);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      return FirebaseFirestore.instance
      .collection('users')
      .where('uid',isEqualTo: postDoc['uid'])
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          batch.update(
            doc.reference,
            {
              'likeNotifications': list,
            }
          );
        });
        return batch.commit();
      });
    } catch(e) {

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
