// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/details/positive_text.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/post_mute/post_mute.dart';
import 'package:whisper/domain/post_report/post_report.dart';
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/user_mute/user_mute.dart';
import 'package:whisper/l10n/l10n.dart';
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
          await voids.showBasicFlutterToast(context: context, msg: l10n.chooseCategory );
        } else {
          // process UI
          final Timestamp now = Timestamp.now();
          final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPost );
          final BookmarkPost bookmarkPost = BookmarkPost(activeUid: mainModel.userMeta.uid,createdAt: now,postId: whisperPost.postId,bookmarkPostCategoryId: mainModel.bookmarkPostCategoryTokenIdNotifier.value,tokenId: tokenId ,passiveUid: whisperPost.uid, tokenType: bookmarkPostTokenType );
          final String uid = mainModel.userMeta.uid;
          mainModel.bookmarksPostIds.add(bookmarkPost.postId);
          mainModel.bookmarkPosts.add(bookmarkPost);
          whisperPost.bookmarkCount += plusOne;
          notifyListeners();
          await (controller as FlashController ).dismiss();
          // backend
          await returnTokenDocRef(uid: uid, tokenId: tokenId).set(bookmarkPost.toJson());
          await addBookmarkSubCol(whisperPost: whisperPost, mainModel: mainModel);
        }
      }, 
      child: PositiveText(text: decideModalText)
    );
  };
  voids.showFlashDialogue(context: context, content: content, titleText: l10n.whichCategory,positiveActionBuilder: positiveActionBuilder);
  }

  Future<void> addBookmarkSubCol({ required Post whisperPost, required MainModel mainModel }) async {
    final String activeUid = mainModel.userMeta.uid;
    final Timestamp now = Timestamp.now();
    final DocumentReference<Map<String,dynamic>> postDocRef = returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId);
    final PostBookmark postBookmark = PostBookmark(activeUid: activeUid,createdAt: now,postId: whisperPost.postId,postCreatorUid: whisperPost.uid,postDocRef: postDocRef );
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

    Future<void> mutePost({ required BuildContext context ,required MainModel mainModel, required int i, required DocumentSnapshot<Map<String,dynamic>> postDoc, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<DocumentSnapshot<Map<String,dynamic>>> results}) async {
    // process set
    final Post whisperPost = fromMapToPost(postMap: postDoc.data()!);
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
    await voids.showBasicFlutterToast(context: context,msg: mutePostMsg);
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(mutePost.toJson());
    final PostMute postMute = PostMute(activeUid: mainModel.userMeta.uid, createdAt: now, postCreatorUid: whisperPost.postId, postDocRef: postDoc.reference, postId: postId);
    await returnPostMuteDocRef(postDoc: postDoc, userMeta: mainModel.userMeta).set(postMute.toJson());
  }

  Future<void> muteUser({ required BuildContext context ,required AudioPlayer audioPlayer, required List<AudioSource> afterUris, required List<String> muteUids, required int i, required List<DocumentSnapshot<Map<String,dynamic>>> results,required List<MuteUser> muteUsers, required Post whisperPost, required MainModel mainModel}) async {
    // process set
    final String passiveUid = whisperPost.uid;
    final Timestamp now = Timestamp.now();
    final UserMeta userMeta = mainModel.userMeta;
    final String tokenId = returnTokenId(userMeta: userMeta, tokenType: TokenType.muteUser );
    final L10n l10n = returnL10n(context: context)!;
    final MuteUser muteUser = MuteUser(activeUid: firebaseAuthCurrentUser()!.uid,createdAt: now,passiveUid: passiveUid,tokenId: tokenId, tokenType: muteUserTokenType );
    // process Ui
    mainModel.muteUsers.add(muteUser);
    mainModel.muteUids.add(whisperPost.uid);
    await removeTheUsersPost(results: results, passiveUid: passiveUid, afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    await voids.showBasicFlutterToast(context: context,msg: l10n.muteUserMsg);
    // process Backend
    await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
    final UserMute userMute = UserMute(createdAt: now, muterUid: userMeta.uid, mutedUid: passiveUid );
    await returnUserMuteDocRef(passiveUid: passiveUid, activeUid: mainModel.userMeta.uid ).set(userMute.toJson());
  }

  Future<void> removeTheUsersPost({ required List<DocumentSnapshot<Map<String,dynamic>>> results,required String passiveUid, required List<AudioSource> afterUris, required AudioPlayer audioPlayer,required int i}) async {
    results.removeWhere((result) => fromMapToPost(postMap: result.data()!).uid == passiveUid);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  }

  Future<void> deletePost({ required BuildContext innerContext, required AudioPlayer audioPlayer,required Post whisperPost,required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) async {
    Navigator.pop(innerContext);
    final L10n l10n = returnL10n(context: innerContext)!;
    if (mainModel.currentUser!.uid != whisperPost.uid) {
      voids.showBasicFlutterToast(context: innerContext, msg: l10n.noRight);
    } else {
      // process UI
      final x = posts[i];
      posts.remove(x);
      mainModel.currentWhisperUser.postCount += minusOne;
      await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
      // process backend
      await x.reference.delete();
      await returnRefFromPost(post: whisperPost).delete();
      if (isImageExist(post: whisperPost) == true) {
        await returnPostImagePostRef(mainModel: mainModel, postId: whisperPost.postId).delete();
      }
      notifyListeners();
    }
  }

  void onPostDeleteButtonPressed({ required BuildContext context, required AudioPlayer audioPlayer,required Post whisperPost,required List<AudioSource> afterUris, required List<DocumentSnapshot<Map<String,dynamic>>> posts,required MainModel mainModel, required int i}) {
    final L10n l10n = returnL10n(context: context)!;
    final title = l10n.deletePost;
    final content = l10n.deletePostAlert;
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text(cancelText),
            onPressed: () => Navigator.pop(innerContext),
          ),
          CupertinoDialogAction(
            child: const Text(okText),
            isDestructiveAction: true,
            onPressed: () async => await deletePost(innerContext: innerContext, audioPlayer: audioPlayer, whisperPost: whisperPost, afterUris: afterUris, posts: posts, mainModel: mainModel, i: i)
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

  void reportPost({ required BuildContext context, required MainModel mainModel, required int i, required Post post, required List<AudioSource> afterUris, required AudioPlayer audioPlayer , required List<DocumentSnapshot<Map<String,dynamic>>> results}) {
    final postDoc = results[i];
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postReportId = generatePostReportId();
    final content = ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier);
    final positiveActionBuilder = (_, controller, __) {
      return TextButton(
        onPressed: () async {
          final PostReport postReport = PostReport(
            activeUid: mainModel.userMeta.uid,
            createdAt: Timestamp.now(), 
            others: '', 
            postCreatorUid: post.uid,
            passiveUserName: post.userName, 
            postDocRef: postDoc.reference, 
            postId: postDoc.id, 
            postReportId: postReportId,
            postTitle: post.title, 
            postTitleLanguageCode: post.titleLanguageCode,
            postTitleNegativeScore: post.titleNegativeScore, 
            postTitlePositiveScore: post.titlePositiveScore, 
            postTitleSentiment: post.titleSentiment,
            reportContent: returnReportContentString(selectedReportContents: selectedReportContentsNotifier.value),
          );
          await (controller as FlashController).dismiss();
          await voids.showBasicFlutterToast(context: context,msg: reportPostMsg);
          await mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: afterUris, audioPlayer: audioPlayer, results: results);
          await returnPostReportDocRef(postDoc: postDoc,postReportId: postReportId ).set(postReport.toJson());
        }, 
        child: PositiveText(text: sendModalText)
      );
    };
    voids.showFlashDialogue(context: context, content: content, titleText: reportTitle, positiveActionBuilder: positiveActionBuilder);
  }
}

