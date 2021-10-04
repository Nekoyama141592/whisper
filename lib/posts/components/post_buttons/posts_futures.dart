// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  Future bookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await addBookmarksToPost(currentUserDoc, postDoc);
    await addBookmarksToUser(currentUserDoc, postDoc);
  }

  Future unpreservate(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    await findOwner(postDoc);
    await removeBookmarksOfPost(currentUserDoc, postDoc);
    await removeBookmarksOfUser(currentUserDoc, postDoc);
  }

  Future findOwner(DocumentSnapshot postDoc) async {
    await FirebaseFirestore.instance
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
      final List likeList = currentUserDoc['likes'];
      final Map<String, dynamic> map = {
        'likedPostId': postDoc['postId'],
        'createdAt': Timestamp.now(),
      };
      likeList.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'likes': likeList,
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

  Future addBookmarksToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      // User ver
      final List bookmarks = postDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      bookmarks.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(postDoc.id)
      .update({
        'bookmarks': bookmarks,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future addBookmarksToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List bookmarks = currentUserDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'postId': postDoc['postId'],
        'createdAt': Timestamp.now(),
      };
      bookmarks.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'bookmarks': bookmarks,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  Future removeBookmarksOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot postDoc) async {
    try {
      // User ver
      final List bookmarks = postDoc['bookmarks'];
      bookmarks.removeWhere((bookmark) => bookmark['uid'] == currentUserDoc['uid']);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(postDoc.id)
      .update({
        'bookmarks': bookmarks,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future removeBookmarksOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot postDoc) async {
    try{
      final List bookmarks = currentUserDoc['bookmarks'];
      bookmarks.removeWhere((bookmark) => bookmark['postId'] == postDoc['postId']);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'bookmarks': bookmarks,
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
      likes.removeWhere((like) => like['likedPostId'] == postDoc['postId']);
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
  
  void reload() {
    notifyListeners();
  }
}
