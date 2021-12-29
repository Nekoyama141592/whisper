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
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
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
  late DocumentSnapshot currentUserDoc;

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
  List<DocumentSnapshot> recommenderDocs = [];
  // block and mutes
  late SharedPreferences prefs;
  List<dynamic> mutesUids = [];
  List<String> mutesPostIds = [];
  List<dynamic> blocksUids = [];
  List<dynamic> blocksIpv6s = [];
  List<dynamic> readPostIds = [];
  List<dynamic> mutesIpv6s = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  final speedNotifier = ValueNotifier<double>(1.0);
  
  RecommendersModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await setCurrentUserDoc();
    prefs = await SharedPreferences.getInstance();
    await setMutesAndBlocks();
    await getRecommenders();
    getReadPostIds();
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
    List<dynamic> readPosts = currentUserDoc['readPosts'];
    readPosts.forEach((readPost) {
      readPostIds.add(readPost['postId']);
    });
  }

  bool isValidReadPost({ required DocumentSnapshot doc}) {
    final now = DateTime.now();
    final DateTime range = now.subtract(Duration(days: 5));
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: doc.data() as Map<String,dynamic> ) && !mutesPostIds.contains(doc['postId']) && doc['createdAt'].toDate().isAfter(range);
  } 

  Future setCurrentUserDoc() async {
    try{
      currentUserDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser!.uid)
      .get();
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> initAudioPlayer(int i) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  Future mutePost(List<String> mutesPostIds,SharedPreferences prefs,int i,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final postId = post['postId'];
    mutesPostIds.add(postId);
    recommenderDocs.removeWhere((result) => result['postId'] == postId);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
    notifyListeners();
    await prefs.setStringList('mutesPostIds', mutesPostIds);
  }

  Future muteUser({ required List<dynamic> mutesUids, required int i, required DocumentSnapshot currentUserDoc, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> post}) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
    await removeTheUsersPost(uid, i);
    voids.addMutesUidAndMutesIpv6AndUid(mutesIpv6AndUids: mutesIpv6AndUids,mutesUids: mutesUids,map: post);
    notifyListeners();
    voids.updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentUserDoc: currentUserDoc);
  }

  Future blockUser({ required List<dynamic> blocksUids, required DocumentSnapshot currentUserDoc, required List<dynamic> blocksIpv6AndUids, required int i, required Map<String,dynamic> post}) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
    await removeTheUsersPost(uid, i);
    voids.addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: post);
    notifyListeners();
    voids.updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: currentUserDoc);
  }
  
  Future removeTheUsersPost(String uid,int i) async {
    recommenderDocs.removeWhere((result) => result['uid'] == uid);
    await voids.resetAudioPlayer(afterUris: afterUris, audioPlayer: audioPlayer, i: i);
  }
  
  Future onRefresh() async {
    await getNewRecommenders();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewRecommenders() async {
    QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
    .collection('posts')
    .orderBy('score', descending: true)
    .endBeforeDocument(recommenderDocs.first)
    .limit(oneTimeReadCount)
    .get();
    
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
     // Sort by oldest first
    docs.reversed;
     // Insert at the top
    docs.forEach((DocumentSnapshot doc) {
      if (isValidReadPost(doc: doc)) {
        recommenderDocs.insert(0, doc);
        Uri song = Uri.parse(doc['audioURL']);
        UriAudioSource source = AudioSource.uri(song, tag: doc);
        afterUris.insert(0, source);
      }
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }

  Future onLoading() async {
    await getOldRecommenders();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future setMutesAndBlocks() async {
    mutesPostIds = prefs.getStringList('mutesPostIds') ?? [];
    final List<dynamic> blocksIpv6AndUids = currentUserDoc['blocksIpv6AndUids'];
    blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
      blocksIpv6s.add(blocksIpv6AndUid['ipv6']);
      blocksUids.add(blocksIpv6AndUid['uid']);
    });
    // mutesIpv6s
    final List<dynamic> mutesIpv6AndUids = currentUserDoc['mutesIpv6AndUids'];
    mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
      mutesIpv6s.add(mutesIpv6AndUid['ipv6']);
      mutesUids.add(mutesIpv6AndUid['uid']);
    });
  }

  Future getRecommenders() async {
    
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('score', descending: true)
      .limit(oneTimeReadCount)
      .get();
      snapshots.docs.forEach((DocumentSnapshot doc) {
        if (isValidReadPost(doc: doc)) {
          recommenderDocs.add(doc);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        }
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist);
      }
    } catch(e) {
      print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!");
    }
    notifyListeners();
  }

  Future<void> getOldRecommenders() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('score', descending: true)
      .startAfterDocument(recommenderDocs.last)
      .limit(oneTimeReadCount)
      .get();
      final lastIndex = recommenderDocs.lastIndexOf(recommenderDocs.last);
      snapshots.docs.forEach((DocumentSnapshot doc) {
        if (isValidReadPost(doc: doc)) {
          recommenderDocs.add(doc);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        }
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

}