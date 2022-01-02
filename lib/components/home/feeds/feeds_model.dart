// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final feedsProvider = ChangeNotifierProvider(
  (ref) => FeedsModel()
);
class FeedsModel extends ChangeNotifier {

  bool isLoading = false;
  User? currentUser;

  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  Query<Map<String,dynamic>> getQuery({ required List<dynamic> followingUids }) {
    final x = postColRef.where('uid',whereIn: followingUids).orderBy('createdAt',descending: true).limit(oneTimeReadCount);
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
  List followingUidsOfModel = [];
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // block and mutes
  late SharedPreferences prefs;
  List<dynamic> mutesIpv6AndUids = [];
  List<dynamic> mutesUids = [];
  List<dynamic> mutesIpv6s = [];
  List<String> mutesPostIds = [];
  List<dynamic> blocksIpv6AndUids = [];
  List<dynamic> blocksUids = [];
  List<dynamic> blocksIpv6s = [];
  //repost
  bool isReposted = false;
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  final speedNotifier = ValueNotifier<double>(1.0);
  // enum
  final PostType postType = PostType.feeds;

  FeedsModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    // await
    await setCurrentUserDoc();
    prefs = await SharedPreferences.getInstance();
    setFollowUids();
    voids.setMutesAndBlocks(prefs: prefs, currentUserDoc: currentUserDoc, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    await getFeeds(followingUids: followingUidsOfModel);
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

  
  Future<void> onRefresh({ required List<dynamic> followingUids }) async {
    await getNewFeeds(followingUids: followingUids);
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload({ required List<dynamic> followingUids }) async {
    startLoading();
    await getFeeds(followingUids: followingUids);
    endLoading();
  }

  Future<void> onLoading({ required List<dynamic> followingUids }) async {
    await getOldFeeds(followingUids: followingUids);
    refreshController.loadComplete();
    notifyListeners();
  }
  
  Future<void> setCurrentUserDoc() async {
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
  }

  void setFollowUids() {
    followingUidsOfModel = currentUserDoc['followingUids'];
    followingUidsOfModel.add(currentUser!.uid);
  }

  Future<void> getNewFeeds({ required List<dynamic> followingUids }) async {
    if (followingUids.isNotEmpty) {
      await voids.processNewPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
    }
  }

  // getFeeds
  Future<void> getFeeds({ required List<dynamic> followingUids }) async {
    try{
      if (followingUids.isNotEmpty) {
        await voids.processBasicPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
      }
    } catch(e) { print(e.toString()); }
  }

  Future<void> getOldFeeds({ required List<dynamic> followingUids }) async {
    try {
      if (followingUids.isNotEmpty) {
        voids.processOldPosts(query: getQuery(followingUids: followingUids), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
      }
    } catch(e) { print(e.toString()); }
  }

}