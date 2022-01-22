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
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final recommendersProvider = ChangeNotifierProvider(
  (ref) => RecommendersModel()
);
class RecommendersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // user
  User? currentUser;
  late UserMeta userMeta;
  late WhisperUser currentWhisperUser;
  Query<Map<String, dynamic>> getQuery() {
    final x = postColRef.orderBy(scoreKey, descending: true).limit(oneTimeReadCount);
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
  
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  // cloudFirestore
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
  List<dynamic> readPostIds = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  final speedNotifier = ValueNotifier<double>(1.0);
  // enum
  final PostType postType = PostType.recommenders;
  
  RecommendersModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await setCurrentUserDoc();
    prefs = await SharedPreferences.getInstance();
    voids.setMutesAndBlocks(prefs: prefs, currentWhisperUser: currentWhisperUser, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    await getRecommenders();
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

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void getReadPostIds() {
    List<dynamic> readPosts = userMeta.readPosts;
    readPosts.forEach((readPost) {
      readPostIds.add(readPost[postIdKey]);
    });
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  Future<void> setCurrentUserDoc() async {
    final userMetaDoc = await FirebaseFirestore.instance.collection(userMetaKey).doc(currentUser!.uid).get();
    userMeta = fromMapToUserMeta(userMetaMap: userMetaDoc.data()!);
    final DocumentSnapshot<Map<String,dynamic>> currentWhisperDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    currentWhisperUser = fromMapToWhisperUser(userMap: currentWhisperDoc.data()! );
  }
  
  Future<void> onRefresh() async {
    await getNewRecommenders();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getRecommenders();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldRecommenders();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewRecommenders() async {
    await voids.processNewPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
  }

  Future<void> getRecommenders() async {
    try {
      await voids.processBasicPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
    } catch(e) { print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!"); }
  }

  Future<void> getOldRecommenders() async {
    try {
      await voids.processOldPosts(query: getQuery(), posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds);
    } catch(e) { print(e.toString()); }
  }

}