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
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/counts.dart';
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

  late DocumentSnapshot currentUserDoc;
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
  List followingUids = [];
  List<DocumentSnapshot> feedDocs = [];
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

  FeedsModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    // await
    prefs = await SharedPreferences.getInstance();
    await setCurrentUserDoc();
    voids.setMutesAndBlocks(prefs: prefs, currentUserDoc: currentUserDoc, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    setFollowUids();
    await getFeeds();
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

  bool isValidReadPost({ required DocumentSnapshot doc}) {
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: doc.data() as Map<String,dynamic>) && !mutesPostIds.contains(doc['postId']);
  }
  
  Future onRefresh() async {
    await getNewFeeds();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewFeeds() async {
    QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
    .collection('posts')
    .where('uid',whereIn: followingUids)
    .orderBy('createdAt',descending: true)
    .endBeforeDocument(feedDocs.first)
    .limit(oneTimeReadCount)
    .get();
    // Sort by oldest first
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
    docs.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
    // Insert at the top
    docs.forEach((DocumentSnapshot doc) {
      if ( isValidReadPost(doc: doc) ) {
        feedDocs.insert(0, doc);
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
    await getOldFeeds();
    refreshController.loadComplete();
    notifyListeners();
  }
  
  Future setCurrentUserDoc() async {
    try{
      currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    } catch(e) {
      print(e.toString());
    }
  }

  void setFollowUids() {
    try {
      followingUids = currentUserDoc['followingUids'];
      followingUids.add(currentUser!.uid);
      notifyListeners();
    } catch(e) {
      print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }
  // getFeeds
  Future getFeeds() async {

    try{
      QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid',whereIn: followingUids)
      .orderBy('createdAt',descending: true)
      .limit(oneTimeReadCount)
      .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshots.docs;
      docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
      if (docs.isNotEmpty) {
        docs.forEach((DocumentSnapshot doc) {
          print(isValidReadPost(doc: doc));
          if ( isValidReadPost(doc: doc) ) {
            feedDocs.add(doc);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          }
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist);
        }
      }
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> getOldFeeds() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid',whereIn: followingUids)
      .orderBy('createdAt',descending: true)
      .startAfterDocument(feedDocs.last)
      .limit(oneTimeReadCount)
      .get();
      final lastIndex = feedDocs.lastIndexOf(feedDocs.last);
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = snapshots.docs;
      docs.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
      if (docs.isNotEmpty) {
        docs.forEach((DocumentSnapshot doc) {
          if ( isValidReadPost(doc: doc) ) {
            feedDocs.add(doc);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          }
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
        }
      }
    } catch(e) {
      print(e.toString());
    }
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }


}