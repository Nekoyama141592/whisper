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

  Future like(List<dynamic> likedPostIds,DocumentSnapshot currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    final String postId = currentSongMap['postId'];
    addPostIdToLikedPostIds(likedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await addLikesToPost(currentUserDoc, newCurrentSongDoc);
    await addLikesToCurrentUser(currentUserDoc, currentSongMap,likes);
  }

  void addPostIdToLikedPostIds(List<dynamic> likedPostIds,String postId) {
    likedPostIds.add(postId);
    notifyListeners();
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
  
  Future addLikesToCurrentUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    try{
      final Map<String, dynamic> map = {
        'likedPostId': currentSongMap['postId'],
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

  Future bookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    final postId = currentSongMap['postId'];
    addPostIdTobookmarkedPostIds(bookmarkedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await addBookmarksToPost(currentUserDoc, newCurrentSongDoc);
    await addBookmarksToUser(currentUserDoc, currentSongMap,bookmarks);
  }

  void addPostIdTobookmarkedPostIds(List<dynamic> bookmarkedPostIds,String postId) {
    bookmarkedPostIds.remove(postId);
    notifyListeners();
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

  Future addBookmarksToUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    try{
      final Map<String, dynamic> map = {
        'postId': currentSongMap['postId'],
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

  Future unbookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    final postId = currentSongMap['postId']; 
    removePostIdFrombookmarkedPostIds(bookmarkedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await removeBookmarksOfPost(currentUserDoc, newCurrentSongDoc);
    await removeBookmarksOfUser(currentUserDoc, currentSongMap, bookmarks);
  }
  
  void removePostIdFrombookmarkedPostIds(List<dynamic> bookmarkedPostIds,String postId) {
    bookmarkedPostIds.remove(postId);
    notifyListeners();
  }
  Future removeBookmarksOfPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
     
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

  Future removeBookmarksOfUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    try{
      bookmarks.removeWhere((bookmark) => bookmark['postId'] == currentSongMap['postId']);
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

  Future unlike(List<dynamic> likedPostIds,DocumentSnapshot currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    final postId = currentSongMap['postId'];
    removePostIdFromLikedPostIds(likedPostIds, postId);
    final newCurrentSongDoc = await getNewCurrentSongDoc(currentSongMap);
    await removeLikeOfPost(currentUserDoc, newCurrentSongDoc);
    await removeLikeOfUser(currentUserDoc, currentSongMap,likes);
  }

  void removePostIdFromLikedPostIds(List<dynamic> likedPostIds,String postId) {
    likedPostIds.remove(postId);
    notifyListeners();
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
  
  Future removeLikeOfUser(DocumentSnapshot currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    try{
      likes.removeWhere((like) => like['likedPostId'] == currentSongMap['postId']);
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

  Future getNewCurrentSongDoc(Map<String,dynamic> currentSongMap) async {
    DocumentSnapshot newCurrentSongDoc = await FirebaseFirestore.instance
    .collection('posts')
    .doc(currentSongMap['objectID'])
    .get();
    return newCurrentSongDoc;
  }
}
