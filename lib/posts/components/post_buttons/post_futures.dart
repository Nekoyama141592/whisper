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
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/bookmark/bookmark.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier{

  Future<void> like({ required Post whisperPost, required MainModel mainModel }) async {
    final String postId = whisperPost.postId;
    final List<dynamic> likePostIds = mainModel.likePostIds;
    // process UI
    likePostIds.add(postId);
    notifyListeners();
    // backend
    await addLikeSubCol(whisperPost: whisperPost, mainModel: mainModel);
    await addLikesToCurrentUser(whisperPost: whisperPost, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).set({
      uidKey: mainModel.currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }
  
  Future<void> addLikesToCurrentUser({ required Post whisperPost, required MainModel mainModel }) async {
    final Map<String, dynamic> map = {
      likePostIdKey: whisperPost.postId,
      createdAtKey: Timestamp.now(),
    };
    final List<dynamic> likes = mainModel.likes;
    likes.add(map);
    await FirebaseFirestore.instance.collection(userMetaKey).doc(mainModel.currentWhisperUser.uid).update({
      likesKey: likes,
    });
  }

  Future<void> bookmark({ required Post whisperPost, required MainModel mainModel }) async {
    final postId = whisperPost.postId;
    final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
    // process UI
    bookmarksPostIds.add(postId);
    notifyListeners();
    // backend
    final Timestamp now = Timestamp.now();
    await addBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
    await addBookmarksToUser(whisperPost: whisperPost, mainModel: mainModel, now: now);
  }

  Future<void> addBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).set({
      uidKey: mainModel.currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }


  Future<void> addBookmarksToUser({ required Post whisperPost, required MainModel mainModel ,required Timestamp now , required String bookmarkLabelId }) async {
    final Map<String, dynamic> map = Bookmark(createdAt: now, postId: whisperPost.postId).toJson();
    final bookmarks = mainModel.bookmarks;
    bookmarks.add(map);
    mainModel.userMeta.bookmarks = bookmarks;
    await FirebaseFirestore.instance.collection(userMetaKey).doc(mainModel.userMeta.uid).update(mainModel.userMeta.toJson());
    await bookmarkLabelRef(uid: mainModel.userMeta.uid, bookmarkLabelId: bookmarkLabelId ).update({
      bookmarksKey: bookmarks,
      updatedAtKey: now,
    });
  }

  Future<void> unbookmark({ required Post whisperPost, required MainModel mainModel }) async {
    final postId = whisperPost.postId;
    final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
    // process UI
    bookmarksPostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
    await removeBookmarksOfUser(whisperPost: whisperPost, mainModel: mainModel);
  }

  Future<void> deleteBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).delete();
  }

  Future<void> removeBookmarksOfUser({ required Post whisperPost, required MainModel mainModel , required String bookmarkLabelId }) async {
    final List<dynamic> bookmarks = mainModel.bookmarks;
    bookmarks.removeWhere((bookmark) => bookmark[postIdKey] == whisperPost.postId);
    await FirebaseFirestore.instance.collection(userMetaKey).doc(mainModel.userMeta.uid).update({
      bookmarksKey: bookmarks,
    });
    await bookmarkLabelRef(uid: mainModel.userMeta.uid, bookmarkLabelId: bookmarkLabelId).update({
      bookmarksKey: FieldValue.arrayRemove(bookmarks.where((element) {
        final Bookmark bookmark = fromMapToBookmark(map: element as Map<String,dynamic>);
        return bookmark.postId == whisperPost.postId;
      }).toList())
    });
  }

   Future<void> unlike({ required Post whisperPost, required MainModel mainModel }) async {
    final postId = whisperPost.postId; 
    // process UI
    mainModel.likePostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(whisperPost: whisperPost,mainModel: mainModel);
    await removeLikeOfUser(whisperPost: whisperPost, mainModel: mainModel);
  }

  Future<void> deleteLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await likeChildRef(parentColKey: postsKey, uniqueId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).delete();
  }
  
  Future<void> removeLikeOfUser({ required Post whisperPost, required MainModel mainModel}) async {
    final List<dynamic> likes = mainModel.likes;
    likes.removeWhere((like) => like[likePostIdKey] == whisperPost.postId);
    await FirebaseFirestore.instance.collection(userMetaKey).doc(mainModel.currentWhisperUser.uid).update({
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