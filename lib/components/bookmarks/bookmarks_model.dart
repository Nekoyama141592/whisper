// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// domain
import 'package:whisper/domain/whisper_user_meta/whisper_user_meta.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final bookmarksProvider = ChangeNotifierProvider(
  (ref) => BookmarksModel()
);

class BookmarksModel extends ChangeNotifier {
  
  bool isLoading = false;
  late UserMeta userMeta;
  // late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  Query<Map<String, dynamic>> getQuery({ required List<dynamic> bookmarkedPostIds}) {
    final x = postColRef.where(postIdKey, whereIn: bookmarkedPostIds).limit(oneTimeReadCount);
    return x;
  }
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
  List<String> bookmarkedPostIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;

  BookmarksModel() {
    init();
  }
  
  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    await setCurrentUserDoc();
    setBookmarkedPostIds();
    await getBookmarks(bookmarkedPostIds);
    prefs = await SharedPreferences.getInstance();
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

  Future<void> onRefresh() async {
    await getNewBookmarks(bookmarkedPostIds);
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getBookmarks(bookmarkedPostIds);
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldBookmarks(bookmarkedPostIds);
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> setCurrentUserDoc() async {
    final userMetaDoc = await FirebaseFirestore.instance.collection(userMetaKey).doc(FirebaseAuth.instance.currentUser!.uid).get();
    userMeta = fromMapToUserMeta(userMetaMap: userMetaDoc.data()!);
  }

  void setBookmarkedPostIds() {
    List maps = userMeta.bookmarks;
    maps.sort((a,b) => b[createdAtKey].compareTo(a[createdAtKey]));
    maps.forEach((map) {
      bookmarkedPostIds.add(map[postIdKey]);
    });
    notifyListeners();
  }

  Future<void> getNewBookmarks(List<dynamic> bookmarkedPostIds) async {
    if (bookmarkedPostIds.isNotEmpty) {
      await voids.processNewPosts(query: getQuery(bookmarkedPostIds: bookmarkedPostIds), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
    }
  }

  Future<void> getBookmarks (List<dynamic> bookmarkedPostIds) async {
    try{
      if (bookmarkedPostIds.isNotEmpty) {
        await voids.processBasicPosts(query: getQuery(bookmarkedPostIds: bookmarkedPostIds), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
      }
    } catch(e) { print(e.toString()); }
  }

  Future<void> getOldBookmarks(List<dynamic> bookmarkedPostIds) async {
    try {
      if (bookmarkedPostIds.isEmpty) {
        await voids.processOldPosts(query: getQuery(bookmarkedPostIds: bookmarkedPostIds), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
      }
    } catch(e) { print(e.toString()); }
  }

}

