// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/details/positive_text.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
// components
import 'package:whisper/l10n/l10n.dart';
// model 
import 'package:whisper/main_model.dart';

final postFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFuturesModel()
);

class PostFuturesModel extends ChangeNotifier {

  Future<void> like({ required Post whisperPost, required MainModel mainModel }) async {
    final String postId = whisperPost.postId;
    final List<String> likePostIds = mainModel.likePostIds;
    // process UI
    likePostIds.add(postId);
    notifyListeners();
    // backend
    await _addLikeSubCol(whisperPost: whisperPost, mainModel: mainModel);
    // create likePostToken
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.likePost );
    final LikePost likePost = LikePost(activeUid: activeUid, createdAt: now, postId: whisperPost.postId,tokenId: tokenId,passiveUid: whisperPost.uid,tokenType: likePostTokenType );
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(likePost.toJson());
    mainModel.likePosts.add(likePost);
  }

  Future<void> _addLikeSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final Timestamp now = Timestamp.now();
    final DocumentReference<Map<String,dynamic>> postDocRef = returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId);
    final PostLike postLike = PostLike(activeUid: mainModel.userMeta.uid, createdAt: now, postId: whisperPost.postId, postCreatorUid: whisperPost.uid,postDocRef: postDocRef );
    await returnPostLikeDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).set(postLike.toJson());
  }


  Future<void> bookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostCategory> bookmarkPostLabels }) async {
    final L10n l10n = returnL10n(context: context)!;
    final Widget content = Container(
      height: flashDialogueHeight(context: context),
      child: ValueListenableBuilder<String>(
        valueListenable: mainModel.bookmarkPostCategoryTokenIdNotifier,
        builder: (_,bookmarkPostLabelId,__) {
          return ListView.builder(
            itemCount: bookmarkPostLabels.length,
            itemBuilder: (BuildContext context, int i) {
              final BookmarkPostCategory bookmarkPostLabel = bookmarkPostLabels[i];
              return ListTile(
                leading: bookmarkPostLabelId == bookmarkPostLabel.tokenId ? Icon(Icons.check) : SizedBox.shrink(),
                title: Text(bookmarkPostLabel.categoryName,style: TextStyle(fontWeight: FontWeight.bold),),
                onTap: () => mainModel.bookmarkPostCategoryTokenIdNotifier.value = bookmarkPostLabel.tokenId,
              );
            }
          );
        }
      ),
    );
    final positiveActionBuilder = (_, controller, __) {
    return TextButton(
      onPressed: () async {
        if (mainModel.bookmarkPostCategoryTokenIdNotifier.value.isEmpty) {
          await voids.showBasicFlutterToast(context: context, msg: l10n.selectCategory );
        } else {
          // process UI
          final Timestamp now = Timestamp.now();
          final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPost );
          final BookmarkPost bookmarkPost = BookmarkPost(activeUid: mainModel.userMeta.uid,createdAt: now,postId: whisperPost.postId,bookmarkPostCategoryId: mainModel.bookmarkPostCategoryTokenIdNotifier.value,tokenId: tokenId ,passiveUid: whisperPost.uid, tokenType: bookmarkPostTokenType );
          final String uid = mainModel.userMeta.uid;
          mainModel.bookmarksPostIds.add(bookmarkPost.postId);
          mainModel.bookmarkPosts.add(bookmarkPost);
          notifyListeners();
          await (controller as FlashController ).dismiss();
          // backend
          await returnTokenDocRef(uid: uid, tokenId: tokenId).set(bookmarkPost.toJson());
          await _addBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
        }
      }, 
      child: PositiveText(text: decideModalText(context: context))
    );
  };
  voids.showFlashDialogue(context: context, content: content, titleText: l10n.whichCategory,positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> _addBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final DocumentReference<Map<String,dynamic>> postDocRef = returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId);
    final PostBookmark postBookmark = PostBookmark(activeUid: activeUid,createdAt: now,postId: whisperPost.postId,postCreatorUid: whisperPost.uid,postDocRef: postDocRef );
    await returnPostBookmarkDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: activeUid).set(postBookmark.toJson());
  }

  Future<void> unbookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostCategory> bookmarkCategories }) async {
    final postId = whisperPost.postId;
    final indexDeleteToken = mainModel.bookmarkPosts.firstWhere((element) => element.postId == whisperPost.postId);
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
    final deleteLikePostToken = mainModel.likePosts.firstWhere((element) => element.postId == whisperPost.postId);
    // process UI
    mainModel.likePostIds.remove(postId);
    mainModel.likePosts.remove(deleteLikePostToken);
    notifyListeners();
    // backend
    await returnPostLikeDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteLikePostToken.tokenId ).delete();
  }
}