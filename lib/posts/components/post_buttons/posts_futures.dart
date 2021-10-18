// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostsFutures()
);

class PostsFutures extends ChangeNotifier{
  
  String comment = '';
  bool isLoading = false;

  Future like(List<dynamic> likedPostIds,DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    final String postId = currentSongDoc['postId'];
    addPostIdToLikedPostIds(likedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await addLikesToPost(currentUserDoc, newCurrentSongDoc);
    await addLikesToCurrentUser(currentUserDoc, currentSongDoc,likes);
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

  Future bookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    final postId = currentSongDoc['postId'];
    addPostIdTobookmarkedPostIds(bookmarkedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await addBookmarksToPost(currentUserDoc, newCurrentSongDoc);
    await addBookmarksToUser(currentUserDoc, currentSongDoc,bookmarks);
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

  Future unbookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> bookmarks) async {
    final postId = currentSongDoc['postId'];
    removePostIdFrombookmarkedPostIds(bookmarkedPostIds, postId);
    final DocumentSnapshot newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await removeBookmarksOfPost(currentUserDoc, newCurrentSongDoc);
    await removeBookmarksOfUser(currentUserDoc, currentSongDoc, bookmarks);
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

   Future unlike(List<dynamic> likedPostIds,DocumentSnapshot currentUserDoc, DocumentSnapshot currentSongDoc,List<dynamic> likes) async {
    final postId = currentSongDoc['postId']; 
    removePostIdFromLikedPostIds(likedPostIds, postId);
    final newCurrentSongDoc = await getNewCurrentSongDoc(currentSongDoc);
    await removeLikeOfPost(currentUserDoc, newCurrentSongDoc);
    await removeLikeOfUser(currentUserDoc, currentSongDoc,likes);
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

  Future mutePost(List<String> mutesPostIds,String postId,SharedPreferences prefs) async {
    mutesPostIds.add(postId);
    notifyListeners();
    await prefs.setStringList('mutesPostIds', mutesPostIds);
  }

  Future muteUser(List<String> mutesUids,String uid,SharedPreferences prefs) async {
    mutesUids.add(uid);
    notifyListeners();
    await prefs.setStringList('mutesUids', mutesUids);
  }

  Future muteReply(List<String> mutesReplyIds,String replyId,SharedPreferences prefs) async {
    mutesReplyIds.add(replyId);
    notifyListeners();
    await prefs.setStringList('mutesReplyIds', mutesReplyIds);
  }

  Future muteComment(List<String> mutesCommentIds,String commentId,SharedPreferences prefs) async {
    mutesCommentIds.add(commentId);
    notifyListeners();
    await prefs.setStringList('mutesCommentIds', mutesCommentIds);
  }

  Future blockUser(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,String passiveUid) async {
    blockingUids.add(passiveUid);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'blocingUids': blockingUids,
    }); 
  }

}
