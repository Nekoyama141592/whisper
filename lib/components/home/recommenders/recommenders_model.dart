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
  List<DocumentSnapshot<Map<String,dynamic>>> recommenderDocs = [];
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
  
  RecommendersModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await setCurrentUserDoc();
    prefs = await SharedPreferences.getInstance();
    voids.setMutesAndBlocks(prefs: prefs, currentUserDoc: currentUserDoc, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
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
    List<dynamic> readPosts = currentUserDoc['readPosts'];
    readPosts.forEach((readPost) {
      readPostIds.add(readPost['postId']);
    });
  }

  bool isValidReadPost({ required DocumentSnapshot<Map<String,dynamic>> doc}) {
    final now = DateTime.now();
    final DateTime range = now.subtract(Duration(days: 5));
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: doc.data() as Map<String,dynamic> ) && !mutesPostIds.contains(doc['postId']) && doc['createdAt'].toDate().isAfter(range);
  } 

  Future setCurrentUserDoc() async {
    try{
      currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    } catch(e) {
      print(e.toString());
    }
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
    docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
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

  Future getRecommenders() async {
    
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('score', descending: true)
      .limit(oneTimeReadCount)
      .get();
      snapshots.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
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
      snapshots.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
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