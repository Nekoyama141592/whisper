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
// domain
import 'package:whisper/domain/bookmark/bookmark.dart';
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
  List<String> bookmarksPostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;
  
  Future<void> init({ required MainModel mainModel }) async {
    startLoading();
    audioPlayer = AudioPlayer();
    await setBookmarksPostIds(userMeta: mainModel.userMeta);
    await getBookmarks(bookmarksPostIds: mainModel.bookmarksPostIds);
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
  //   await getNewBookmarks(bookmarksPostIds: bookmarksPostIds);
  //   refreshController.refreshCompleted();
  //   notifyListeners();
  // }

  Future<void> onReload() async {
    startLoading();
    await getBookmarks(bookmarksPostIds: bookmarksPostIds);
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldBookmarks(bookmarksPostIds: bookmarksPostIds);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> setBookmarksPostIds({ required UserMeta userMeta }) async {
    // List<Bookmark> maps = userMeta.bookmarks.map((bookmark) => fromMapToBookmark(map: bookmark) ).toList();
    // maps.sort((a,b) => (b.createdAt as Timestamp ).compareTo(a.createdAt));
    // maps.forEach((map) {
    //   bookmarksPostIds.add(map.postId);
    // });
    await bookmarkLabelParentRef(uid: userMeta.uid).get().then((qshot) {
      final DocumentSnapshot<Map<String,dynamic>> first = qshot.docs.first;
      final BookmarkLabel bookmarkLabel = fromMapToBookmarkLabel(map: first.data()!);
      final List<Bookmark> bookmarks = (bookmarkLabel.bookmarks as List<dynamic> ).map((bookmark) => fromMapToBookmark(map: bookmark as Map<String,dynamic> ) ).toList();
      bookmarks.sort((a,b) => (b.createdAt as Timestamp ).compareTo(a.createdAt as Timestamp ));
      bookmarksPostIds = bookmarks.map((bookmark) => bookmark.postId ).toList();
    });
    notifyListeners();
  }

  Future<void> getBookmarks({ required List<String> bookmarksPostIds}) async {
    if (bookmarksPostIds.isNotEmpty) { await processBookmark(); }
  }

  Future<void> processBookmark() async {
    List<String> max30 = bookmarksPostIds.length > (lastIndex + oneTimeReadCount) ? bookmarksPostIds.sublist(0,(oneTimeReadCount - 1)) : bookmarksPostIds.sublist( 0,bookmarksPostIds.indexOf(bookmarksPostIds.last) );
    List<String> max10 = [];
    List<DocumentSnapshot<Map<String,dynamic>>> docs = [];
    max30.forEach((element) async {
      max10.add(element);
      if (max10.length == 10) {
        await FirebaseFirestore.instance.collection(postsKey).where(postIdKey,whereIn: max10).get().then((qshot) {
          qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.add(doc); });
        });
        max10 = [];
      }
      if (max10.isNotEmpty) {
        await FirebaseFirestore.instance.collection(postsKey).where(postIdKey,whereIn: max10).get().then((qshot) {
          qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { docs.add(doc); });
        });
      }
    });
    voids.basicProcessContent(docs: docs, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
    lastIndex += max30.indexOf(bookmarksPostIds.last);
  }

  // Future<void> getNewBookmarks({ required List<String> bookmarksPostIds}) async {
    
  // }


  Future<void> getOldBookmarks({ required List<String> bookmarksPostIds}) async {
    if (bookmarksPostIds.length > (lastIndex + oneTimeReadCount)) {
      await processBookmark();
    }
  }

}

