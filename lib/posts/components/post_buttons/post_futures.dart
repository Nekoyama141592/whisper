// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
// model 
import 'package:whisper/main_model.dart';

final postsFeaturesProvider = ChangeNotifierProvider(
  (ref) => PostFutures()
);

class PostFutures extends ChangeNotifier {

  Future<void> like({ required Post whisperPost, required MainModel mainModel }) async {
    final String postId = whisperPost.postId;
    final List<String> likePostIds = mainModel.likePostIds;
    // process UI
    likePostIds.add(postId);
    whisperPost.likeCount += plusOne;
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


  Future<void> bookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostCategory> bookmarkPostLabels }) async {
    final Widget content = Container(
      height: MediaQuery.of(context).size.height * 0.70,
      child: ValueListenableBuilder<String>(
        valueListenable: mainModel.bookmarkPostLabelTokenIdNotifier,
        builder: (_,bookmarkPostLabelId,__) {
          return ListView.builder(
            itemCount: bookmarkPostLabels.length,
            itemBuilder: (BuildContext context, int i) {
              final BookmarkPostCategory bookmarkPostLabel = bookmarkPostLabels[i];
              return ListTile(
                leading: bookmarkPostLabelId == bookmarkPostLabel.tokenId ? Icon(Icons.check) : SizedBox.shrink(),
                title: Text(bookmarkPostLabel.categoryName),
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
        final BookmarkPost bookmarkPost = BookmarkPost(activeUid: mainModel.userMeta.uid,createdAt: now,postId: whisperPost.postId,bookmarkPostCategoryId: mainModel.bookmarkPostLabelTokenIdNotifier.value,tokenId: tokenId ,passiveUid: whisperPost.uid, tokenType: bookmarkPostTokenType );
        final String uid = mainModel.userMeta.uid;
        mainModel.bookmarksPostIds.add(bookmarkPost.postId);
        mainModel.bookmarkPosts.add(bookmarkPost);
        whisperPost.bookmarkCount += plusOne;
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

  Future<void> unbookmark({ required BuildContext context ,required Post whisperPost, required MainModel mainModel, required List<BookmarkPostCategory> bookmarkCategories }) async {
    final postId = whisperPost.postId;
    final indexDeleteToken = mainModel.bookmarkPosts.where((element) => element.postId == whisperPost.postId).toList().first;
    // processUI
    mainModel.bookmarksPostIds.remove(postId);
    mainModel.bookmarkPosts.remove(indexDeleteToken);
    whisperPost.bookmarkCount += minusOne;
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
    whisperPost.likeCount += minusOne;
    notifyListeners();
    // backend
    await returnPostLikeDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId, activeUid: mainModel.userMeta.uid ).delete();
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: deleteLikePostToken.tokenId ).delete();
  }

    Future<void> mutePost({ required MainModel mainModel, required int i, required Map<String,dynamic> post, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<DocumentSnapshot<Map<String,dynamic>>> results}) async {
    // process set
    final Post whisperPost = fromMapToPost(postMap: post);
    final String postId = whisperPost.postId;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.mutePost );
    final MutePost mutePost = MutePost(activeUid: mainModel.userMeta.uid, createdAt: now, postId: postId,tokenId: tokenId,passiveUid: whisperPost.uid,tokenType: mutePostTokenType );
    // process UI
    mainModel.mutePostIds.add(postId);
    mainModel.mutePosts.add(mutePost);
    results.removeWhere((result) => fromMapToPost(postMap: result.data()!).postId == whisperPost.postId );
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(mutePost.toJson());
  }

  Future<void> muteUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> mutesUids, required int i, required List<DocumentSnapshot<Map<String,dynamic>>> results,required List<MuteUser> muteUsers, required Map<String,dynamic> post, required MainModel mainModel}) async {
    // process set
    final whisperPost = fromMapToPost(postMap: post);
    final String passiveUid = whisperPost.uid;
    final Timestamp now = Timestamp.now();
    final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
    final MuteUser muteUser = MuteUser(activeUid: firebaseAuthCurrentUser!.uid,createdAt: now,passiveUid: passiveUid,tokenId: tokenId, tokenType: muteUserTokenType );
    // process Ui
    mainModel.muteUsers.add(muteUser);
    mainModel.muteUids.add(whisperPost.uid);
    await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
  }

  // Future<void> blockUser({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> blocksUids, required List<BlockUser> blockUsers, required int i, required List<DocumentSnapshot<Map<String,dynamic>>> results, required Map<String,dynamic> post, required MainModel mainModel}) async {
  //   // process set
  //   final whisperPost = fromMapToPost(postMap: post);
  //   final String passiveUid = whisperPost.uid;
  //   final Timestamp now = Timestamp.now();
  //   final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
  //   final BlockUser blockUser = BlockUser(createdAt: now,activeUid: mainModel.userMeta.uid,passiveUid: passiveUid,tokenId: tokenId, tokenType: blockUserTokenType );
  //   // process UI
  //   blockUsers.add(blockUser);
  //   blocksUids.add(passiveUid);
  //   await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  //   notifyListeners();
  //   // process Backend
  //   await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
  // }

  Future<void> removeTheUsersPost({ required List<DocumentSnapshot<Map<String,dynamic>>> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
    results.removeWhere((result) => fromMapToPost(postMap: result.data()!).uid == passiveUid);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  }

  Future<void> deletePost({ required BuildContext innerContext, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) async {
    Navigator.pop(innerContext);
    final whisperPost = fromMapToPost(postMap: postMap);
    if (mainModel.currentUser!.uid != whisperPost.uid) {
      voids.showSnackBar(context: innerContext, text: 'あなたにはその権限がありません');
    } else {
      // process UI
      posts.remove(posts[i]);
      mainModel.currentWhisperUser.postCount += minusOne;
      await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      // process backend
      await returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ).delete();
      await returnRefFromPost(post: whisperPost).delete();
      if (isImageExist(post: whisperPost) == true) {
        await returnPostImagePostRef(mainModel: mainModel, postId: whisperPost.postId).delete();
      }
      notifyListeners();
    }
  }

  void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Map<String,dynamic> postMap, required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) {
    final title = '投稿削除';
    final content = '一度削除したら、復元はできません。本当に削除しますか？';
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text(cancelMsg),
            onPressed: () {
              Navigator.pop(innerContext);
            },
          ),
          CupertinoDialogAction(
            child: const Text(okMsg),
            isDestructiveAction: true,
            onPressed: () async { await deletePost(innerContext: innerContext, audioPlayer: audioPlayer, postMap: postMap, afterUris: afterUris, posts: posts, mainModel: mainModel, i: i) ;},
          ),
        ],
      );
    };
    voids.showCupertinoDialogue(context: context, builder: builder );
  } 
  Future<void> initAudioPlayer({ required AudioPlayer audioPlayer, required List<AudioSource> afterUris ,required int i}) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }
}

