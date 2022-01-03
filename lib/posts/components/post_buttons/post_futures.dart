// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier{

  Future<void> like(List<dynamic> likedPostIds,DocumentSnapshot<Map<String,dynamic>> currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    final String postId = currentSongMap[postIdKey];
    // process UI
    likedPostIds.add(postId);
    notifyListeners();
    // backend
    await addLikeSubCol(currentSongMap: currentSongMap, currentUserDoc: currentUserDoc);
    await addLikesToCurrentUser(currentUserDoc, currentSongMap,likes);
  }
 
  // Future<void> addLikesToPost(DocumentSnapshot<Map<String,dynamic>> currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
  //   try {
  //     final List likes = newCurrentSongDoc[likesKey];
  //     final Map<String, dynamic> map = {
  //       createdAtKey: Timestamp.now(),
  //       uidKey: currentUserDoc[uidKey],
  //     };
  //     int score = newCurrentSongDoc[scoreKey];
  //     score += likeScore;
  //     int likesCount = newCurrentSongDoc['likesCount'];
  //     likesCount += 1;
  //     likes.add(map);
  //     await FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(newCurrentSongDoc.id)
  //     .update({
  //       likesKey: likes,
  //       scoreKey: score,
  //       'likesCount': likesCount,
  //     });
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> addLikeSubCol({ required Map<String,dynamic> currentSongMap, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: currentSongMap[postIdKey], activeUid: currentUserDoc.id).set({
      uidKey: currentUserDoc.id,
      createdAtKey: Timestamp.now(),
    });
  }
  
  Future<void> addLikesToCurrentUser(DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    final Map<String, dynamic> map = {
      likedPostIdKey: currentSongMap[postIdKey],
      createdAtKey: Timestamp.now(),
    };
    likes.add(map);
    await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id).update({
      likesKey: likes,
    });
  }

  Future<void> bookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot<Map<String,dynamic>> currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    final postId = currentSongMap[postIdKey];
    // process UI
    bookmarkedPostIds.add(postId);
    notifyListeners();
    // backend
    await addBookmarkSubCol(currentSongMap: currentSongMap, currentUserDoc: currentUserDoc);
    await addBookmarksToUser(currentUserDoc, currentSongMap,bookmarks);
  }

  // Future<void> addBookmarksToPost(DocumentSnapshot<Map<String,dynamic>> currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
  //   try {
  //     final List bookmarks = newCurrentSongDoc[bookmarksKey];
  //     final Map<String, dynamic> map = {
  //       createdAtKey: Timestamp.now(),
  //       uidKey: currentUserDoc[uidKey],
  //     };
  //     bookmarks.add(map);
  //     int score = newCurrentSongDoc[scoreKey];
  //     score += bookmarkScore;
  //     int bookmarksCount = newCurrentSongDoc['bookmarksCount'];
  //     bookmarksCount += 1;
  //     await FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(newCurrentSongDoc.id)
  //     .update({
  //       bookmarksKey: bookmarks,
  //       scoreKey: score,
  //       'bookmarksCount': bookmarksCount,
  //     });
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> addBookmarkSubCol({ required Map<String,dynamic> currentSongMap, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc }) async {
    await bookmarkChildRef(postId: currentSongMap[postIdKey], activeUid: currentUserDoc.id).set({
      uidKey: currentUserDoc.id,
      createdAtKey: Timestamp.now(),
    });
  }


  Future<void> addBookmarksToUser(DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    final Map<String, dynamic> map = {
      postIdKey: currentSongMap[postIdKey],
      createdAtKey: Timestamp.now(),
    };
    bookmarks.add(map);
    await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id).update({
      bookmarksKey: bookmarks,
    });
  }

  Future<void> unbookmark(List<dynamic> bookmarkedPostIds,DocumentSnapshot<Map<String,dynamic>> currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    final postId = currentSongMap[postIdKey];
    // process UI
    bookmarkedPostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteBookmarkSubCol(currentSongMap: currentSongMap, currentUserDoc: currentUserDoc);
    await removeBookmarksOfUser(currentUserDoc, currentSongMap, bookmarks);
  }

  Future<void> deleteBookmarkSubCol({ required Map<String,dynamic> currentSongMap, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc }) async {
    await bookmarkChildRef(postId: currentSongMap[postIdKey], activeUid: currentUserDoc.id).delete();
  }


  // Future<void> removeBookmarksOfPost(DocumentSnapshot<Map<String,dynamic>> currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
  //   try {
  //     final List<dynamic> bookmarks = newCurrentSongDoc[bookmarksKey];
  //     bookmarks.removeWhere((bookmark) => bookmark[uidKey] == currentUserDoc[uidKey]);
  //     int score = newCurrentSongDoc[scoreKey];
  //     score -= bookmarkScore;
  //     int bookmarksCount = newCurrentSongDoc['bookmarksCount'];
  //     bookmarksCount -= 1;
  //     await FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(newCurrentSongDoc.id)
  //     .update({
  //       bookmarksKey: bookmarks,
  //       scoreKey: score,
  //       'bookmarksCount': bookmarksCount,
  //     });
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> removeBookmarksOfUser(DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> bookmarks) async {
    bookmarks.removeWhere((bookmark) => bookmark[postIdKey] == currentSongMap[postIdKey]);
    await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id).update({
      bookmarksKey: bookmarks,
    });
  }

   Future<void> unlike(List<dynamic> likedPostIds,DocumentSnapshot<Map<String,dynamic>> currentUserDoc, Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    final postId = currentSongMap[postIdKey]; 
    // process UI
    likedPostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(currentSongMap: currentSongMap, currentUserDoc: currentUserDoc);
    await removeLikeOfUser(currentUserDoc, currentSongMap,likes);
  }

  // Future<void> removeLikeOfPost(DocumentSnapshot<Map<String,dynamic>> currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    
  //   int score = newCurrentSongDoc[scoreKey];
  //   score -= likeScore;
  //   int likesCount = newCurrentSongDoc['likesCount'];
  //   likesCount -= 1;
  //   try {
  //     final List likes = newCurrentSongDoc[likesKey];
  //     likes.removeWhere((like) => like[uidKey] == currentUserDoc[uidKey]);
  //     await FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(newCurrentSongDoc.id)
  //     .update({
  //       likesKey: likes,
  //       scoreKey: score,
  //       'likesCount': likesCount,
  //     });
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }

  Future<void> deleteLikeSubCol({ required Map<String,dynamic> currentSongMap, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: currentSongMap[postIdKey], activeUid: currentUserDoc.id).delete();
  }
  
  Future<void> removeLikeOfUser(DocumentSnapshot<Map<String,dynamic>> currentUserDoc,Map<String,dynamic> currentSongMap,List<dynamic> likes) async {
    likes.removeWhere((like) => like[likedPostIdKey] == currentSongMap[postIdKey]);
    await FirebaseFirestore.instance.collection(usersKey).doc(currentUserDoc.id).update({
      likesKey: likes,
    });
  }
  
  void reload() {
    notifyListeners();
  }

  Future<void> muteUser({ required List<dynamic> mutesUids,required DocumentSnapshot<Map<String,dynamic>> currentUserDoc, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> map}) async {
    voids.addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: map);
    notifyListeners();
    voids.updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentUserDoc: currentUserDoc);
  }

  Future<void> blockUser({ required List<dynamic> blocksUids, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc, required List<dynamic> blocksIpv6AndUids, required Map<String,dynamic> map}) async {
    voids.addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: map);
    notifyListeners();
    voids.updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: currentUserDoc);
  }

  Future<void> muteComment(List<String> mutesCommentIds,String commentId,SharedPreferences prefs) async {
    mutesCommentIds.add(commentId);
    notifyListeners();
    await prefs.setStringList('mutesCommentIds', mutesCommentIds);
  }

}