// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
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
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
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
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
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
  int lastIndex = 0;
  List<String> bookmarkPostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;
  
  Future<void> init({ required MainModel mainModel,required BookmarkLabel bookmarkLabel }) async {
    startLoading();
    audioPlayer = AudioPlayer();
    await setBookmarksPostIds(userMeta: mainModel.userMeta, bookmarkLabel: bookmarkLabel);
    await getBookmarks();
    prefs = mainModel.prefs;
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
    voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    endLoading();
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

  // Future<void> onRefresh() async {
  //   await getNewBookmarks(bookmarkPostIds: bookmarkPostIds);
  //   refreshController.refreshCompleted();
  //   notifyListeners();
  // }

  Future<void> onReload() async {
    startLoading();
    await getBookmarks();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldBookmarks();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> setBookmarksPostIds({ required UserMeta userMeta,required BookmarkLabel bookmarkLabel }) async {
    final String bookmarkLabelId = bookmarkLabel.bookmarkLabelId;
    await tokensParentRef(uid: userMeta.uid).where(tokenTypeFieldKey,isEqualTo: bookmarkPostTokenType).where(bookmarkLabelIdFieldKey,isEqualTo: bookmarkLabelId).get().then((qshot){
      bookmarkPostIds = qshot.docs.map((e) => BookmarkPost.fromJson(e.data()).postId ).toList();
    });
    notifyListeners();
  }

  Future<void> getBookmarks() async {
    await processBookmark();
  }

  Future<void> processBookmark() async {
    if (bookmarkPostIds.isNotEmpty) {
      List<String> max10 = bookmarkPostIds.length > (lastIndex + tenCount) ? bookmarkPostIds.sublist(0,tenCount) : bookmarkPostIds.sublist( 0,bookmarkPostIds.length );
      List<DocumentSnapshot<Map<String,dynamic>>> docs = [];
      await FirebaseFirestore.instance.collection(postsFieldKey).where(postIdFieldKey,whereIn: max10).get().then((qshot) {
        docs = qshot.docs;
      });
      await voids.basicProcessContent(docs: docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
      lastIndex = posts.length;
    }
  }

  Future<void> getOldBookmarks() async {
    if (bookmarkPostIds.length > (lastIndex + tenCount)) {
      await processBookmark();
    }
  }

}

