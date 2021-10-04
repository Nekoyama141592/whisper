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
  
  Future like(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    await findOwner(currentSongDoc);
    await addLikesToPost(currentUserDoc, currentSongDoc);
    await addLikesToUser(currentUserDoc, currentSongDoc);
    await addLikeNotificationsToUser(currentUserDoc, currentSongDoc);
  }

  Future unlike(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    await removeLikeOfPost(currentUserDoc, currentSongDoc);
    await removeLikeOfUser(currentUserDoc, currentSongDoc);
    await removeLikeNotificationsOfUser(currentUserDoc, currentSongDoc);
  }

  Future bookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    await addBookmarksToPost(currentUserDoc, currentSongDoc);
    await addBookmarksToUser(currentUserDoc, currentSongDoc);
  }

  Future unpreservate(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    await findOwner(currentSongDoc);
    await removeBookmarksOfPost(currentUserDoc, currentSongDoc);
    await removeBookmarksOfUser(currentUserDoc, currentSongDoc);
  }

  Future findOwner(DocumentSnapshot currentSongDoc) async {
    await FirebaseFirestore.instance
    .collection('users')
    .where('uid',isEqualTo: currentSongDoc['uid'])
    .get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot doc) {
        owner = doc;
      });
    });
  }

 
  Future addLikesToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    try {
      final List likes = currentSongDoc['likes'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      likes.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'likes': likes,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future addLikesToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      final List likeList = currentUserDoc['likes'];
      final Map<String, dynamic> map = {
        'likedPostId': currentSongDoc['postId'],
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

  Future addLikeNotificationsToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
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
      .where('uid',isEqualTo: currentSongDoc['uid'])
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

  Future addBookmarksToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    try {
      // User ver
      final List bookmarks = currentSongDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      bookmarks.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'bookmarks': bookmarks,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future addBookmarksToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      final List bookmarks = currentUserDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'postId': currentSongDoc['postId'],
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
  Future removeBookmarksOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    try {
      // User ver
      final List bookmarks = currentSongDoc['bookmarks'];
      bookmarks.removeWhere((bookmark) => bookmark['uid'] == currentUserDoc['uid']);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'bookmarks': bookmarks,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future removeBookmarksOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      final List bookmarks = currentUserDoc['bookmarks'];
      bookmarks.removeWhere((bookmark) => bookmark['postId'] == currentSongDoc['postId']);
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

  Future removeLikeOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    try {
      final List likes = currentSongDoc['likes'];
      likes.removeWhere((like) => like['uid'] == currentUserDoc['uid']);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDoc.id)
      .update({
        'likes': likes,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future removeLikeOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      final List likes = currentUserDoc['likes'];
      likes.removeWhere((like) => like['likedPostId'] == currentSongDoc['postId']);
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
  Future removeLikeNotificationsOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      List list = owner['likeNotifications'];
      
      list.removeWhere((likeNotification) => likeNotification['uid'] == currentUserDoc['uid']);

      WriteBatch batch = FirebaseFirestore.instance.batch();

      return FirebaseFirestore.instance
      .collection('users')
      .where('uid',isEqualTo: currentSongDoc['uid'])
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
