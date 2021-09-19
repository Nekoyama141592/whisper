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
    await findOwner(postDoc);
    await addLikesToPost(currentUserDoc, postDoc);
    await addLikesToUser(currentUserDoc, postDoc);
    await addLikeNotificationsToUser(currentUserDoc, postDoc);
  }

  Future unlike(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await removeLikeOfPost(currentUserDoc, postDoc);
    await removeLikeOfUser(currentUserDoc, postDoc);
    await removeLikeNotificationsOfUser(currentUserDoc, postDoc);
  }

  Future preservate(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await addPreservationsToPost(currentUserDoc, postDoc);
    await addPreservationsToUser(currentUserDoc, postDoc);
  }

  Future unpreservate(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await findOwner(postDoc);
    await removePreservationsOfPost(currentUserDoc, postDoc);
    await removePreservationsOfUser(currentUserDoc, postDoc);
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

  Future addLikesToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
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
  
  Future addLikesToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
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

  Future addLikeNotificationsToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
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

  Future addPreservationsToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
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

  Future addPreservationsToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
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
  Future removePreservationsOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      // User ver
      final List preservations = postDoc['preservations'];
      preservations.removeWhere((preservation) => preservation['uid'] == currentUserDoc['uid']);
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

  Future removePreservationsOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List preservations = currentUserDoc['preservations'];
      preservations.removeWhere((preservation) => preservation['uid'] == postDoc['uid']);
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

  Future removeLikeOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      final List likes = postDoc['likes'];
      likes.removeWhere((like) => like['uid'] == currentUserDoc['uid']);
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
  
  Future removeLikeOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List likes = currentUserDoc['likes'];
      likes.removeWhere((like) => like['uid'] == postDoc['uid']);
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
  Future removeLikeNotificationsOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      List list = owner['likeNotifications'];
      
      list.removeWhere((likeNotification) => likeNotification['uid'] == currentUserDoc['uid']);

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
