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

  
  Future like(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await addLikesToPost(currentUserDoc, newCurrentSongDoc);
    await addLikesToCurrentUser(currentUserDoc, currentSongDoc);
  }

  // Future unlike(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
  //   await removeLikeOfPost(currentUserDoc, currentSongDoc);
  //   await removeLikeOfUser(currentUserDoc, currentSongDoc);
  // }

 
  Future addLikesToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
      final List likes = newCurrentSongDoc['likes'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      likes.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'likes': likes,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  
  Future addLikesToCurrentUser(DocumentSnapshot newCurrentUserDoc,DocumentSnapshot currentSongDoc) async {
    try{
      final List likeList = newCurrentUserDoc['likes'];
      final Map<String, dynamic> map = {
        'likedPostId': currentSongDoc['postId'],
        'createdAt': Timestamp.now(),
      };
      likeList.add(map);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(newCurrentUserDoc.id)
      .update({
        'likes': likeList,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future bookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await addBookmarksToPost(currentUserDoc, newCurrentSongDoc);
    await addBookmarksToUser(currentUserDoc, currentSongDoc);
  }

  // Future unbookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc) async {
  //   final DocumentSnapshot passiveUserDoc = await setPassiveUserDoc(currentSongDoc);
  //   await removeBookmarksOfPost(currentUserDoc, currentSongDoc);
  //   await removeBookmarksOfUser(currentUserDoc, currentSongDoc);
  // }

  Future addBookmarksToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
      final List bookmarks = newCurrentSongDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'uid': currentUserDoc['uid'],
        'createdAt': Timestamp.now(),
      };
      bookmarks.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
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
  
  void reload() {
    notifyListeners();
  }

  Future getNewCurrentSongDoc(DocumentSnapshot currentSongDoc) async {
    DocumentSnapshot newCurrentSongDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(currentSongDoc.id)
    .get();
    return newCurrentSongDoc;
  }
}
