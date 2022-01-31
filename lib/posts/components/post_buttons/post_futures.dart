// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier {

  Future<void> like({ required Post whisperPost, required MainModel mainModel }) async {
    final String postId = whisperPost.postId;
    final List<String> likePostIds = mainModel.likePostIds;
    // process UI
    likePostIds.add(postId);
    notifyListeners();
    // backend
    await addLikeSubCol(whisperPost: whisperPost, mainModel: mainModel);
    await addLikesToCurrentUser(whisperPost: whisperPost, mainModel: mainModel);
  }

  Future<void> addLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final Timestamp now = Timestamp.now();
    final PostLike postLike = PostLike(activeUid: mainModel.userMeta.uid, createdAt: now, postId: whisperPost.postId);
    await returnPostLikeDocRef(uid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).set(postLike.toJson());
  }
  
  Future<void> addLikesToCurrentUser({ required Post whisperPost, required MainModel mainModel }) async {
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.likePost );
    final LikePost likePost = LikePost(activeUid: activeUid, createdAt: now, postId: whisperPost.postId,tokenId: tokenId );
    mainModel.likePostIds.add(whisperPost.postId);
    mainModel.likePosts.add(likePost);
    notifyListeners();
    await returnTokenDocRef(uid: activeUid, tokenId: tokenId).set(likePost.toJson());
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
        final List<String> bookmarksPostIds = mainModel.bookmarksPostIds;
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
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final PostBookmark postBookmark = PostBookmark(activeUid: activeUid,createdAt: now,postId: whisperPost.postId);
    await returnPostBookmarkDocRef(uid: whisperPost.uid, postId: whisperPost.postId, activeUid: activeUid).set(postBookmark.toJson());
  }


  Future<void> addBookmarksToUser({ required Post whisperPost, required MainModel mainModel ,required Timestamp now,required String bookmarkLabelId  }) async {
    final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPost );
    final BookmarkPost bookmarkPost = BookmarkPost(activeUid: mainModel.userMeta.uid,createdAt: now,postId: whisperPost.postId,bookmarkLabelId: bookmarkLabelId,tokenId: tokenId );
    final String uid = mainModel.userMeta.uid;
    mainModel.bookmarkPosts.add(bookmarkPost);
    mainModel.bookmarksPostIds.add(bookmarkPost.postId);
    await returnTokenDocRef(uid: uid, tokenId: tokenId).set(bookmarkPost.toJson());
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
          final List<String> bookmarksPostIds = mainModel.bookmarksPostIds;
          // process UI
          bookmarksPostIds.remove(postId);
          notifyListeners();
          // backend
          await deleteBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
          await deleteBookmarkPostTokenDoc(whisperPost: whisperPost, mainModel: mainModel, bookmarkLabelId: mainModel.bookmarkLabelId);
        }, 
        child: Text('OK')
      );
    };
    voids.showFlashDialogue(context: context, content: content, positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> deleteBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await returnPostBookmarkDocRef(uid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
  }

  Future<void> deleteBookmarkPostTokenDoc({ required Post whisperPost, required MainModel mainModel , required String bookmarkLabelId }) async {
    mainModel.bookmarksPostIds.remove(whisperPost.postId);
    notifyListeners();
    final deleteBookmarkPostToken = mainModel.bookmarkPosts.where((element) => element.postId == whisperPost.postId).toList().first;
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteBookmarkPostToken.tokenId ).delete();
  }

   Future<void> unlike({ required Post whisperPost, required MainModel mainModel }) async {
    final postId = whisperPost.postId; 
    // process UI
    mainModel.likePostIds.remove(postId);
    notifyListeners();
    // backend
    await deleteLikeSubCol(whisperPost: whisperPost,mainModel: mainModel);
    await deleteLikePostTokenDoc(whisperPost: whisperPost, mainModel: mainModel);
  }

  Future<void> deleteLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    await returnPostLikeDocRef(uid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
  }
  
  Future<void> deleteLikePostTokenDoc({ required Post whisperPost, required MainModel mainModel}) async {
    mainModel.likePostIds.remove(whisperPost.postId);
    notifyListeners();
    final String uid = mainModel.userMeta.uid;
    final deleteLikePostToken = mainModel.likePosts.where((element) => element.postId == whisperPost.postId).toList().first;
    await returnTokenDocRef(uid: uid, tokenId: deleteLikePostToken.tokenId ).delete();
  }
  
  void reload() {
    notifyListeners();
  }

  Future<void> muteUser({ required MainModel mainModel, required String passiveUid,required String ipv6}) async {
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
    final MuteUser muteUser = MuteUser(activeUid:mainModel.userMeta.uid, uid: passiveUid,ipv6: ipv6,createdAt: now,tokenId: tokenId);
    mainModel.muteUsers.add(muteUser);
    mainModel.muteUids.add(muteUser.uid);
    notifyListeners();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
  }

  Future<void> blockUser({ required MainModel mainModel, required String passiveUid,required String ipv6}) async {
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
    final BlockUser blockUser = BlockUser(createdAt: now,ipv6: ipv6,uid: passiveUid,tokenId: tokenId);
    mainModel.blockUsers.add(blockUser);
    mainModel.blockUids.add(blockUser.uid);
    notifyListeners();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
  }

  Future<void> muteComment({ required MainModel mainModel, required String commentId }) async {
    final muteCommentIds = mainModel.muteCommentIds;
    muteCommentIds.add(commentId);
    notifyListeners();
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(now: now, userMeta: mainModel.userMeta, tokenType: TokenType.muteComment );
    final MuteComment muteComment = MuteComment(activeUid: mainModel.userMeta.uid,commentId: commentId,createdAt: now, tokenId: tokenId);
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteComment.toJson());
    await mainModel.prefs.setStringList(muteCommentIdsPrefsKey, muteCommentIds);
  }
}