// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/counts.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier{
  
  String comment = '';
  bool isLoading = false;

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
        'createdAt': Timestamp.now(),
        'uid': currentUserDoc['uid'],
      };
      int score = newCurrentSongDoc['score'];
      score += likeScore;
      int likesCount = newCurrentSongDoc['likesCount'];
      likesCount += 1;
      likes.add(map);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'likes': likes,
        'score': score,
        'likesCount': likesCount,
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
    bookmarkedPostIds.add(postId);
    notifyListeners();
  }

  Future addBookmarksToPost(DocumentSnapshot currentUserDoc, DocumentSnapshot newCurrentSongDoc) async {
    try {
      final List bookmarks = newCurrentSongDoc['bookmarks'];
      final Map<String, dynamic> map = {
        'createdAt': Timestamp.now(),
        'uid': currentUserDoc['uid'],
      };
      bookmarks.add(map);
      int score = newCurrentSongDoc['score'];
      score += bookmarkScore;
      int bookmarksCount = newCurrentSongDoc['bookmarksCount'];
      bookmarksCount += 1;
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'bookmarks': bookmarks,
        'score': score,
        'bookmarksCount': bookmarksCount,
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
      int score = newCurrentSongDoc['score'];
      score -= bookmarkScore;
      int bookmarksCount = newCurrentSongDoc['bookmarksCount'];
      bookmarksCount -= 1;
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'bookmarks': bookmarks,
        'score': score,
        'bookmarksCount': bookmarksCount,
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
    
    int score = newCurrentSongDoc['score'];
    score -= likeScore;
    int likesCount = newCurrentSongDoc['likesCount'];
    likesCount -= 1;
    try {
      final List likes = newCurrentSongDoc['likes'];
      likes.removeWhere((like) => like['uid'] == currentUserDoc['uid']);
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(newCurrentSongDoc.id)
      .update({
        'likes': likes,
        'score': score,
        'likesCount': likesCount,
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
    .doc(currentSongMap['postId'])
    .get();
    return newCurrentSongDoc;
  }

  Future muteUser(DocumentSnapshot currentUserDoc,List<dynamic> mutesUids,String uid) async {
    // use on comment or reply
    mutesUids.add(uid);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'mutesUids': mutesUids,
    }); 
  }

  Future blockUser(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,String passiveUid) async {
    // use on comment or reply
    blockingUids.add(passiveUid);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'blocingUids': blockingUids,
    }); 
  }

  // Future muteUserFromPost(DocumentSnapshot currentUserDoc,List<dynamic> mutesUids,String uid,int i,List<dynamic> posts,List<AudioSource> afterUris,AudioPlayer audioPlayer,int refreshIndex) async {
  //   // posts is List<DocumentSnapshot> or List<Map<String,dynamic>>
  //   mutesUids.add(uid);
  //   posts.removeWhere((postDoc) => postDoc['uid'] == uid);
  //   await resetAudioPlayer(i,afterUris,posts,audioPlayer,refreshIndex);
  //   await FirebaseFirestore.instance
  //   .collection('users')
  //   .doc(currentUserDoc.id)
  //   .update({
  //     'mutesUids': mutesUids,
  //   }); 
  // }

  // Future blockUserFromPost(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,String passiveUid,int i,List<dynamic> posts,List<AudioSource> afterUris,AudioPlayer audioPlayer,int refreshIndex) async {
  //   // posts is List<DocumentSnapshot> or List<Map<String,dynamic>>
  //   blockingUids.add(passiveUid);
  //   posts.removeWhere((postDoc) => postDoc['uid'] == passiveUid);
  //   await resetAudioPlayer(i, afterUris, posts, audioPlayer,refreshIndex);
  //   await FirebaseFirestore.instance
  //   .collection('users')
  //   .doc(currentUserDoc.id)
  //   .update({
  //     'blocingUids': blockingUids,
  //   }); 
  // }

  // Future mutePost(List<String> mutesPostIds,String postId,SharedPreferences prefs,int i,List<dynamic> posts,List<AudioSource> afterUris,AudioPlayer audioPlayer,int refreshIndex) async {
  //   // posts is List<DocumentSnapshot> or List<Map<String,dynamic>>
  //   mutesPostIds.add(postId);
  //   posts.removeWhere((bookmarkedDoc) => bookmarkedDoc['postId'] == postId);
  //   await resetAudioPlayer(i, afterUris, posts, audioPlayer,refreshIndex);
  //   await prefs.setStringList('mutesPostIds', mutesPostIds);
  // }

  //  Future resetAudioPlayer(int i,List<AudioSource> afterUris,List<dynamic> posts,AudioPlayer audioPlayer,int refreshIndex) async {
  //   // posts is List<DocumentSnapshot> or List<Map<String,dynamic>>
    // AudioSource source = afterUris[i];
    // afterUris.remove(source);
  //   if (afterUris.isNotEmpty) {
  //     ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
  //     await audioPlayer.setAudioSource(
  //       playlist,
  //       initialIndex: i == 0 ? i :  i - 1
  //     );
  //   }
  //   // refreshIndex = posts.length -1;
  //   notifyListeners();
  // }

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

}
