// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
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
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier {

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
    mainModel.likePostIds.add(whisperPost.postId);
    notifyListeners();
    final String activeUid = mainModel.userMeta.uid;
    final DateTime now = DateTime.now();
    final LikePost likePost = LikePost(activeUid: activeUid, createdAt: Timestamp.fromDate(now), postId: whisperPost.postId );
    await newTokenChildRef(uid: activeUid, now: now).set(likePost.toJson());
  }

  Future<void> bookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkLabel> bookmarkLabels }) async {
    final Widget content = SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: 300.0,
      child: ListView.builder(
        itemCount: bookmarkLabels.length,
        itemBuilder: (BuildContext context, int i) {
          final BookmarkLabel bookmarkLabel = bookmarkLabels[i];
          return ListTile(
            leading: mainModel.bookmarkLabelId == bookmarkLabel.bookmarkLabelId ? Icon(Icons.check) : SizedBox.shrink(),
            title: Text(bookmarkLabel.label),
            onTap: () {
              mainModel.bookmarkLabelId = bookmarkLabel.bookmarkLabelId;
            },
          );
        }
      ),
    );
  final positiveActionBuilder = (_, controller, __) {
    return TextButton(
      onPressed: () async {
        final postId = whisperPost.postId;
        final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
        // process UI
        bookmarksPostIds.add(postId);
        notifyListeners();
        (controller as FlashController ).dismiss();
        // backend
        final Timestamp now = Timestamp.now();
        await addBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
        await addBookmarksToUser(whisperPost: whisperPost, mainModel: mainModel, now: now, bookmarkLabelId: mainModel.bookmarkLabelId);
      }, 
      child: Text('OK', style: textStyle(context: context), )
    );
  };
  voids.showFlashDialogue(context: context, content: content, positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> addBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).set({
      uidKey: mainModel.currentWhisperUser.uid,
      createdAtKey: Timestamp.now(),
    });
  }


  Future<void> addBookmarksToUser({ required Post whisperPost, required MainModel mainModel ,required Timestamp now , required String bookmarkLabelId }) async {
    final Bookmark bookmark = Bookmark(activeUid: mainModel.userMeta.uid,createdAt: Timestamp.now(),postId: whisperPost.postId,);
    final String uid = mainModel.userMeta.uid;
    await newTokenChildRef(uid: uid, now: now.toDate()).set(bookmark.toJson());
    await bookmarkLabelRef(uid: mainModel.userMeta.uid, bookmarkLabelId: bookmarkLabelId ).update({
      bookmarksKey: FieldValue.arrayUnion([bookmark]),
      updatedAtKey: now,
    });
  }

  Future<void> unbookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkLabel> bookmarkLabels }) async {
    final Widget content = 
    SingleChildScrollView(
      child: ListView.builder(
        itemCount: bookmarkLabels.length,
        itemBuilder: (BuildContext context, int i) {
          final BookmarkLabel bookmarkLabel = bookmarkLabels[i];
          return ListTile(
            leading: mainModel.bookmarkLabelId == bookmarkLabel.bookmarkLabelId ? Icon(Icons.check) : SizedBox.shrink(),
            title: Text(bookmarkLabel.label),
            onTap: () {
              mainModel.bookmarkLabelId = bookmarkLabel.bookmarkLabelId;
            },
          );
        }
      )
    );
    final positiveActionBuilder = (context, controller, _) {
      return TextButton(
        onPressed: () async {
          (controller as FlashController ).dismiss();
          final postId = whisperPost.postId;
          final List<dynamic> bookmarksPostIds = mainModel.bookmarksPostIds;
          // process UI
          bookmarksPostIds.remove(postId);
          notifyListeners();
          // backend
          await deleteBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
          await removeBookmarksOfUser(whisperPost: whisperPost, mainModel: mainModel, bookmarkLabelId: mainModel.bookmarkLabelId);
        }, 
        child: Text('OK')
      );
    };
    voids.showFlashDialogue(context: context, content: content, positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> deleteBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await bookmarkChildRef(postId: whisperPost.postId, activeUid: mainModel.currentWhisperUser.uid).delete();
  }

  Future<void> removeBookmarksOfUser({ required Post whisperPost, required MainModel mainModel , required String bookmarkLabelId }) async {
    mainModel.bookmarksPostIds.remove(whisperPost.postId);
    notifyListeners();
    final qshot = await tokensParentRef(uid: mainModel.userMeta.uid).where(postIdKey,isEqualTo: whisperPost.postId).get();
    final DocumentSnapshot<Map<String,dynamic>> alreadyBookmark = qshot.docs.first;
    await alreadyTokenRef(userMeta: mainModel.userMeta, alreadyTokenDocId: alreadyBookmark.id ).delete();
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
    mainModel.likePostIds.remove(whisperPost.postId);
    final DateTime now = DateTime.now();
    final String uid = mainModel.userMeta.uid;
    final LikePost likePost = LikePost(activeUid: uid, createdAt: Timestamp.fromDate(now), postId: whisperPost.postId);
    await newTokenChildRef(uid: uid, now: now).set(likePost.toJson());
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