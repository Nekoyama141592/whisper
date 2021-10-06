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

  Future like(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await addLikesToPost(currentUserDoc, newCurrentSongDoc);
    await addLikesToCurrentUser(currentUserDoc, currentSongDoc,likes);
  }
 
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
  
  Future addLikesToCurrentUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    try{
      final Map<String, dynamic> map = {
        'likedPostId': currentSongDoc['postId'],
        'createdAt': Timestamp.now(),
      };
      likes.add(map);
      notifyListeners();
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

  Future bookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    // await addBookmarksToPost(currentUserDoc, newCurrentSongDoc);
    // await addBookmarksToUser(currentUserDoc, currentSongDoc,bookmarks);
  }

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

  Future addBookmarksToUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    try{
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

   Future unbookmark(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await removeBookmarksOfPost(currentUserDoc, newCurrentSongDoc);
    await removeBookmarksOfUser(currentUserDoc, currentSongDoc, bookmarks);
  }

  Future removeBookmarksOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
      // User ver
      // final List bookmarks = currentSongDoc['bookmarks'];
      final List<dynamic> bookmarks = newCurrentSongDoc['bookmarks'];
      bookmarks.removeWhere((bookmark) => bookmark['uid'] == currentUserDoc['uid']);
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

  Future removeBookmarksOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    try{
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

   Future unlike(DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    // await removeLikeOfPost(currentUserDoc, currentSongDoc);
    final newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await removeLikeOfPost(currentUserDoc, newCurrentSongDoc);
    await removeLikeOfUser(currentUserDoc, currentSongDoc,likes);
  }

  Future removeLikeOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
      final List likes = newCurrentSongDoc['likes'];
      likes.removeWhere((like) => like['uid'] == currentUserDoc['uid']);
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
  
  Future removeLikeOfUser(DocumentSnapshot currentUserDoc,DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    try{
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
    .collection('posts')
    .doc(currentSongDoc.id)
    .get();
    return newCurrentSongDoc;
  }
}
