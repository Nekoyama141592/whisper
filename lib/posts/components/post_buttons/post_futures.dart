// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/main_model.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier{

  Future<void> like({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final String postId = currentSongMap[postIdKey];
    final List<dynamic> likePostIds = mainModel.likePostIds;
    // process UI
    likePostIds.add(postId);
    notifyListeners();
    // backend
    await addLikeSubCol(currentSongMap: currentSongMap, mainModel: mainModel);
    await addLikesToCurrentUser(currentSongMap: currentSongMap, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: currentSongMap[postIdKey], activeUid: mainModel.currentWhisperUser.uid).set({
      uidKey: mainModel.currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }
  
  Future<void> addLikesToCurrentUser({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final Map<String, dynamic> map = {
      likePostIdKey: currentSongMap[postIdKey],
      createdAtKey: Timestamp.now(),
    };
    final List<dynamic> likes = mainModel.likes;
    likes.add(map);
    await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid).update({
      likesKey: likes,
    });
  }

  Future<void> bookmark({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final postId = currentSongMap[postIdKey];
    final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
    // process UI
    bookmarksPostIds.add(postId);
    notifyListeners();
    // backend
    await addBookmarkSubCol(currentSongMap: currentSongMap, mainModel: mainModel);
    await addBookmarksToUser(currentSongMap: currentSongMap, mainModel: mainModel);
  }

  Future<void> addBookmarkSubCol({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: currentSongMap[postIdKey], activeUid: mainModel.currentWhisperUser.uid).set({
      uidKey: mainModel.currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }


  Future<void> addBookmarksToUser({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final Map<String, dynamic> map = {
      postIdKey: currentSongMap[postIdKey],
      createdAtKey: Timestamp.now(),
    };
    final bookmarks = mainModel.bookmarks;
    bookmarks.add(map);
    await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid).update({
      bookmarksKey: bookmarks,
    });
  }

  Future<void> unbookmark({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final postId = currentSongMap[postIdKey];
    final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
    // process UI
    bookmarksPostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteBookmarkSubCol(currentSongMap: currentSongMap, mainModel: mainModel);
    await removeBookmarksOfUser(currentSongMap: currentSongMap, mainModel: mainModel);
  }

  Future<void> deleteBookmarkSubCol({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: currentSongMap[postIdKey], activeUid: mainModel.currentWhisperUser.uid).delete();
  }

  Future<void> removeBookmarksOfUser({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final List<dynamic> bookmarks = mainModel.bookmarks;
    bookmarks.removeWhere((bookmark) => bookmark[postIdKey] == currentSongMap[postIdKey]);
    await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid).update({
      bookmarksKey: bookmarks,
    });
  }

   Future<void> unlike({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    final postId = currentSongMap[postIdKey]; 
    // process UI
    mainModel.likePostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(currentSongMap: currentSongMap,mainModel: mainModel);
    await removeLikeOfUser(currentSongMap: currentSongMap, mainModel: mainModel);
  }

  Future<void> deleteLikeSubCol({ required Map<String,dynamic> currentSongMap, required MainModel mainModel }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: currentSongMap[postIdKey], activeUid: mainModel.currentWhisperUser.uid).delete();
  }
  
  Future<void> removeLikeOfUser({ required Map<String,dynamic> currentSongMap, required MainModel mainModel}) async {
    final List<dynamic> likes = mainModel.likes;
    likes.removeWhere((like) => like[likePostIdKey] == currentSongMap[postIdKey]);
    await FirebaseFirestore.instance.collection(usersKey).doc(mainModel.currentWhisperUser.uid).update({
      likesKey: likes,
    });
  }
  
  void reload() {
    notifyListeners();
  }

  Future<void> muteUser({ required MainModel mainModel, required Map<String,dynamic> map}) async {
    final List<dynamic> mutesUids = mainModel.mutesUids;
    final List<dynamic> mutesIpv6AndUids = mainModel.mutesIpv6AndUids;
    voids.addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: map);
    notifyListeners();
    voids.updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentWhisperUser: mainModel.currentWhisperUser);
  }

  Future<void> blockUser({ required MainModel mainModel, required Map<String,dynamic> map}) async {
    final List<dynamic> blocksIpv6AndUids = mainModel.blocksIpv6AndUids;
    final List<dynamic> blocksUids = mainModel.blocksUids;
    voids.addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: map);
    notifyListeners();
    voids.updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentWhisperUser: mainModel.currentWhisperUser);
  }

  Future<void> muteComment(List<String> mutesCommentIds,String commentId,SharedPreferences prefs) async {
    mutesCommentIds.add(commentId);
    notifyListeners();
    await prefs.setStringList(mutesCommentIdsKey, mutesCommentIds);
  }

}