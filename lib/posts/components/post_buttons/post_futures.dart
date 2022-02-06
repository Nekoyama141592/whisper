// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/enums.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/mute_comment/mute_comment.dart';
import 'package:whisper/domain/mute_reply/mute_reply.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/bookmark_post_label/bookmark_post_label.dart';
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
    // create likePostToken
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.likePost );
    final LikePost likePost = LikePost(activeUid: activeUid, createdAt: now, postId: whisperPost.postId,tokenId: tokenId,passiveUid: whisperPost.uid,tokenType: likePostTokenType );
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(likePost.toJson());
    mainModel.likePosts.add(likePost);
  }

  Future<void> addLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final Timestamp now = Timestamp.now();
    final PostLike postLike = PostLike(activeUid: mainModel.userMeta.uid, createdAt: now, postId: whisperPost.postId, postCreatorUid: whisperPost.uid);
    await returnPostLikeDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).set(postLike.toJson());
  }


  Future<void> bookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostLabel> bookmarkPostLabels }) async {
    final Widget content = SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: ValueListenableBuilder<String>(
        valueListenable: mainModel.bookmarkPostLabelTokenIdNotifier,
        builder: (_,bookmarkPostLabelId,__) {
          return ListView.builder(
            itemCount: bookmarkPostLabels.length,
            itemBuilder: (BuildContext context, int i) {
              final BookmarkPostLabel bookmarkPostLabel = bookmarkPostLabels[i];
              return ListTile(
                leading: bookmarkPostLabelId == bookmarkPostLabel.tokenId ? Icon(Icons.check) : SizedBox.shrink(),
                title: Text(bookmarkPostLabel.label),
                onTap: () {
                  mainModel.bookmarkPostLabelTokenIdNotifier.value = bookmarkPostLabel.tokenId;
                },
              );
            }
          );
        }
      ),
    );
  final positiveActionBuilder = (_, controller, __) {
    return TextButton(
      onPressed: () async {
        // process UI
        final Timestamp now = Timestamp.now();
        final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPost );
        final BookmarkPost bookmarkPost = BookmarkPost(activeUid: mainModel.userMeta.uid,createdAt: now,postId: whisperPost.postId,bookmarkLabelId: mainModel.bookmarkPostLabelTokenIdNotifier.value,tokenId: tokenId ,passiveUid: whisperPost.uid, tokenType: bookmarkPostTokenType );
        final String uid = mainModel.userMeta.uid;
        mainModel.bookmarksPostIds.add(bookmarkPost.postId);
        mainModel.bookmarkPosts.add(bookmarkPost);
        notifyListeners();
        (controller as FlashController ).dismiss();
        // backend
        await returnTokenDocRef(uid: uid, tokenId: tokenId).set(bookmarkPost.toJson());
        await addBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
      }, 
      child: Text('OK', style: textStyle(context: context), )
    );
  };
  voids.showFlashDialogue(context: context, content: content, titleText: 'どのリストにブックマークしますか？',positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> addBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final PostBookmark postBookmark = PostBookmark(activeUid: activeUid,createdAt: now,postId: whisperPost.postId,postCreatorUid: whisperPost.uid );
    await returnPostBookmarkDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: activeUid).set(postBookmark.toJson());
  }

  Future<void> unbookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostLabel> bookmarkLabels }) async {
    final postId = whisperPost.postId;
    final indexDeleteToken = mainModel.bookmarkPosts.where((element) => element.postId == whisperPost.postId).toList().first;
    // processUI
    mainModel.bookmarksPostIds.remove(postId);
    mainModel.bookmarkPosts.remove(indexDeleteToken);
    notifyListeners();
    // backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: indexDeleteToken.tokenId ).delete();
    await returnPostBookmarkDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
  }

   Future<void> unlike({ required Post whisperPost, required MainModel mainModel }) async {
    final postId = whisperPost.postId; 
    final deleteLikePostToken = mainModel.likePosts.where((element) => element.postId == whisperPost.postId).toList().first;
    // process UI
    mainModel.likePostIds.remove(postId);
    mainModel.likePosts.remove(deleteLikePostToken);
    notifyListeners();
    // backend
    await returnPostLikeDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteLikePostToken.tokenId ).delete();
  }
  
  void reload() {
    notifyListeners();
  }

  Future<void> muteUser({ required MainModel mainModel, required String passiveUid,}) async {
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
    final MuteUser muteUser = MuteUser(activeUid:mainModel.userMeta.uid, passiveUid: passiveUid, createdAt: now,tokenId: tokenId, tokenType: muteUserTokenType );
    mainModel.muteUsers.add(muteUser);
    mainModel.muteUids.add(muteUser.passiveUid);
    notifyListeners();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
  }

  Future<void> blockUser({ required MainModel mainModel, required String passiveUid,}) async {
    // process set
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
    final BlockUser blockUser = BlockUser(createdAt: now, activeUid: mainModel.userMeta.uid,passiveUid: passiveUid,tokenId: tokenId,tokenType: blockUserTokenType );
    // process UI
    mainModel.blockUsers.add(blockUser);
    mainModel.blockUids.add(blockUser.passiveUid);
    notifyListeners();
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
  }

  Future<void> muteComment({ required MainModel mainModel, required WhisperPostComment whisperComment }) async {
    // process set
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.mutePostComment );
    final String postCommentId = whisperComment.postCommentId;
    final MuteComment muteComment = MuteComment(activeUid: mainModel.userMeta.uid,postCommentId: postCommentId,createdAt: now, tokenId: tokenId, tokenType: mutePostCommentTokenType,postCommentDocRef: returnPostCommentDocRef(postCreatorUid: whisperComment.passiveUid, postId: whisperComment.postId, postCommentId: postCommentId, ), );
    // process UI
    mainModel.mutePostCommentIds.add(postCommentId);
    mainModel.mutePostComments.add(muteComment);
    notifyListeners();
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteComment.toJson());
  }

  Future<void> muteReply({ required MainModel mainModel, required WhisperReply whisperReply }) async {
    // process set
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePostCommentReply );
    final MuteReply muteReply = MuteReply(activeUid: mainModel.userMeta.uid, createdAt: now, postCommentReplyId: whisperReply.postCommentReplyId, tokenType: mutePostCommentReplyTokenType, postCommentReplyDocRef: postDocRefToPostCommentReplyDocRef(postDocRef: whisperReply.postDocRef, postCommentId: whisperReply.postCommentId, postCommentReplyId: whisperReply.postCommentReplyId ) );
    // process UI
    mainModel.mutePostCommentReplyIds.add(muteReply.postCommentReplyId);
    mainModel.mutePostCommentReplys.add(muteReply);
    notifyListeners();
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteReply.toJson());
  }
}