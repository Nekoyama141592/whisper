// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
// domain
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

final bookmarksProvider = ChangeNotifierProvider(
  (ref) => BookmarksModel()
);

class BookmarksModel extends ChangeNotifier {
  
  bool isLoading = false;
  // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<String> bookmarkPostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;
  // init
  bool isInitFinished = false;
  String indexBookmarkPostLabelId = '';
  bool isBookmarkMode = false;
  // editLabel
  String editLabel = '';
  // new
  String newLabel = '';
  
  Future<void> init({required BuildContext context ,required MainModel mainModel,required BookmarkPostCategory bookmarkLabel }) async {
    isBookmarkMode = true;
    notifyListeners();
    if (indexBookmarkPostLabelId != bookmarkLabel.tokenId) {
      indexBookmarkPostLabelId = bookmarkLabel.tokenId;
      bookmarkPostIds = [];
      posts = [];
      startLoading();
      audioPlayer = AudioPlayer();
      setBookmarksPostIds(mainModel: mainModel, );
      await processBookmark();
      prefs = mainModel.prefs;
      await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
      if (isInitFinished == false) {
        voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentWhisperPostNotifier: currentWhisperPostNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
        isInitFinished = true;
      }
      endLoading();
    }
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  void back() {
    isBookmarkMode = false;
    notifyListeners();
  }

  Future<void> onReload({ required MainModel mainModel }) async {
    startLoading();
    setBookmarksPostIds(mainModel: mainModel);
    await processBookmark();
    endLoading();
  }

  Future<void> onLoading() async {
    await processOldBookmark();
    refreshController.loadComplete();
    notifyListeners();
  }

  void setBookmarksPostIds({ required MainModel mainModel, }){
    List<BookmarkPost> x = mainModel.bookmarkPosts.where((element) => element.bookmarkPostCategoryId == indexBookmarkPostLabelId ).toList();
    x.sort((a,b)=> (b.createdAt as Timestamp ).compareTo(a.createdAt) );
    bookmarkPostIds = x.map((e) => e.postId ).toList();
    notifyListeners();
  }

  Future<void> processBookmark() async {
    if (bookmarkPostIds.length > posts.length) {
      final bool = (bookmarkPostIds.length - posts.length) > 10;
      final int postsLength = posts.length;
      List<String> max10BookmarkPostIds = bool ? bookmarkPostIds.sublist(postsLength,postsLength + tenCount ) : bookmarkPostIds.sublist(postsLength,bookmarkPostIds.length);
      if (max10BookmarkPostIds.isNotEmpty) {
        final query = returnPostsColGroupQuery().where(postIdFieldKey,whereIn: max10BookmarkPostIds).limit(tenCount);
        await voids.processBasicPosts(query: query, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
      }
    }
  }
  Future<void> processOldBookmark() async {
    if (bookmarkPostIds.length > posts.length) {
      final bool = (bookmarkPostIds.length - posts.length) > 10;
      final int postsLength = posts.length;
      List<String> max10BookmarkPostIds = bool ? bookmarkPostIds.sublist(postsLength,postsLength + tenCount ) : bookmarkPostIds.sublist(postsLength,bookmarkPostIds.length);
      if (max10BookmarkPostIds.isNotEmpty) {
        final query = returnPostsColGroupQuery().where(postIdFieldKey,whereIn: max10BookmarkPostIds).limit(tenCount);
        await voids.processOldPosts(query: query, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, muteUids: [], blockUids: [], mutePostIds: []);
      }
    }
  }

  Future<void> onUpdateLabelButtonPressed({ required BuildContext context  ,required FlashController flashController,required BookmarkPostCategory bookmarkPostCategory,required UserMeta userMeta}) async {
    if (editLabel.isEmpty) {
      voids.showSnackBar(context: context, text: '空欄は不適です');
    } else if (editLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      bookmarkPostCategory.categoryName = editLabel;
      // process UI
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: userMeta.uid, tokenId: bookmarkPostCategory.tokenId ).update(bookmarkPostCategory.toJson());
      editLabel = '';
    }
  }

  Future<void> addBookmarkPostLabel({ required MainModel mainModel, required BuildContext context,required FlashController flashController, }) async {
    if (newLabel.isEmpty) {
      voids.showSnackBar(context: context, text: '空欄は不適です');
    } else if (newLabel.length > maxSearchLength) {
      voids.maxSearchLengthAlert(context: context, isUserName: false );
    } else {
      // process set
      final now = Timestamp.now();
      final String tokenId = returnTokenId(userMeta: mainModel.userMeta, tokenType: TokenType.bookmarkPostCategory );
      final BookmarkPostCategory bookmarkPostCategory = BookmarkPostCategory(createdAt: now,updatedAt: now,tokenType: bookmarkPostCategoryTokenType,imageURL: '',uid: mainModel.userMeta.uid,tokenId: tokenId,categoryName: newLabel);
      bookmarkPostCategory.categoryName = newLabel;
      // process Ui
      mainModel.bookmarkPostCategories.add(bookmarkPostCategory);
      flashController.dismiss();
      notifyListeners();
      // process backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: bookmarkPostCategory.tokenId ).set(bookmarkPostCategory.toJson());
      newLabel = '';
    }
  }

}

