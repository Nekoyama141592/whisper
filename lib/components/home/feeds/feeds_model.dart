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
import 'package:whisper/constants/counts.dart';
// components
import 'package:whisper/details/rounded_button.dart';
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
  List<dynamic> mutesUids = [];
  List<String> mutesPostIds = [];
  List<dynamic> blockingUids = [];
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
    await setCurrentUserDoc();
    await setMutesAndBlocks();
    setFollowUids();
    await getFeeds();
    setSpeed();
    listenForStates();
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

  

  Future initAudioPlayer(int i) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }

  Future resetAudioPlayer(int i) async {
    // Abstractions in post_futures.dart cause Range errors.
    AudioSource source = afterUris[i];
    afterUris.remove(source);
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist,initialIndex: i == 0 ? i :  i - 1);
    } 
  }

  Future mutePost(List<String> mutesPostIds,String postId,SharedPreferences prefs,int i) async {
    // Abstractions in post_futures.dart cause Range errors.
    mutesPostIds.add(postId);
    feedDocs.removeWhere((result) => result['postId'] == postId);
    await resetAudioPlayer(i);
    notifyListeners();
    await prefs.setStringList('mutesPostIds', mutesPostIds);
  }

  Future muteUser(List<dynamic> mutesUids,String uid,SharedPreferences prefs,int i,DocumentSnapshot currentUserDoc,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    mutesUids.add(uid);
    mutesIpv6AndUids.add({
      'ipv6': post['ipv6'],
      'uid': uid,
    });
    await removeTheUsersPost(uid, i);
    notifyListeners();
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
    .update({
      'mutesUids': mutesUids,
      'mutesIpv6AndUids': mutesIpv6AndUids,
    }); 
  }

  Future blockUser(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,String uid,int i,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    blockingUids.add(uid);
    mutesIpv6AndUids.add({
      'ipv6': post['ipv6'],
      'uid': uid,
    });
    await removeTheUsersPost(uid, i);
    notifyListeners();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'blockingUids': blockingUids,
      'mutesIpv6AndUids': mutesIpv6AndUids,
    }); 
  }

  Future removeTheUsersPost(String uid,int i) async {
    feedDocs.removeWhere((result) => result['uid'] == uid);
    await resetAudioPlayer(i);
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
    .endBeforeDocument(feedDocs[0])
    .limit(oneTimeReadCount)
    .get();
    // Sort by oldest first
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
    docs.sort((a,b) => a['createdAt'].compareTo(b['createdAt']));
    // Insert at the top
    docs.forEach((DocumentSnapshot? doc) {
      if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) ) {
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

  Future setMutesAndBlocks() async {
    prefs = await SharedPreferences.getInstance();
    mutesUids = prefs.getStringList('mutesUids') ?? [];
    mutesPostIds = prefs.getStringList('mutesPostIds') ?? [];
    blockingUids = currentUserDoc['blockingUids'];
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
        docs.forEach((DocumentSnapshot? doc) {
          if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) ) {
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
        docs.forEach((DocumentSnapshot? doc) {
          if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) ) {
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

  void play(List<dynamic> readPostIds,List<dynamic> readPosts,DocumentSnapshot currentUserDoc)  {
    audioPlayer.play();
    notifyListeners();
    final postId = currentSongMapNotifier.value['postId'];
    if (!readPostIds.contains(postId)) {
      final map = {
        'createdAt': Timestamp.now(),
        'durationInt': 0,
        'postId': postId,
      };
      readPosts.add(map);
      FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'readPosts': readPosts,
      });
    }
  }


  void pause() {
    audioPlayer.pause();
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }
  // showPage
  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  void onPreviousSongButtonPressed() {
    audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed() {
    audioPlayer.seekToNext();
  }

  void setSpeed() {
    speedNotifier.value = prefs.getDouble('speed') ?? 1.0;
    audioPlayer.setSpeed(speedNotifier.value);
  }

  Future speedControll() async {
    if (speedNotifier.value == 4.0) {
      speedNotifier.value = 1.0;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble('speed', speedNotifier.value);
    } else {
      speedNotifier.value += 0.5;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble('speed', speedNotifier.value);
    }
  }

  void listenForStates() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration();
    listenForChangesInSequenceState();
  }
  void listenForChangesInPlayerState() {
    audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        audioPlayer.seek(Duration.zero);
        audioPlayer.pause();
      }
    });
  }

  void listenForChangesInPlayerPosition() {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInBufferedPosition() {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInTotalDuration() {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void listenForChangesInSequenceState() {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      // update current song doc
      final currentItem = sequenceState.currentSource;
      final DocumentSnapshot<Map<String,dynamic>>? currentSongDoc = currentItem?.tag;
      currentSongMapNotifier.value = currentSongDoc!.data() as Map<String,dynamic>;
      // update playlist
      final playlist = sequenceState.effectiveSequence;
      // update shuffle mode
      isShuffleModeEnabledNotifier.value = 
      sequenceState.shuffleModeEnabled;
      // update previous and next buttons
      if (playlist.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true; 
      } else {
        isFirstSongNotifier.value = playlist.first == currentItem;
        isLastSongNotifier.value = playlist.last == currentItem;
      }
    });
    notifyListeners();
  }

  


  void onDeleteButtonPressed(BuildContext context,DocumentSnapshot postDoc,DocumentSnapshot currentUserDoc,int i) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('投稿を削除'),
          content: Text('投稿を削除しますか？'),
          actions: [
            TextButton(onPressed: (){Navigator.pop(context);}, child: Text('cancel',style: TextStyle(color: Theme.of(context).focusColor,fontWeight: FontWeight.bold),)),
            RoundedButton(
              text: 'OK', 
              widthRate: 0.2, 
              verticalPadding: 20.0, 
              horizontalPadding: 10.0, 
              press: () async { await delete(context, postDoc, currentUserDoc, i); }, 
              textColor: Colors.white, 
              buttonColor: Theme.of(context).highlightColor
            )
          ],
        );
      }
    );
  }


  Future delete(BuildContext context,DocumentSnapshot postDoc, DocumentSnapshot currentUserDoc,int i) async {
    if (currentUserDoc['uid'] != postDoc['uid']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
    } else {
      try {
        AudioSource source = afterUris[i];
        afterUris.remove(source);
        feedDocs.remove(postDoc);
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: i);
        }
        notifyListeners();
        await FirebaseFirestore.instance
        .collection('posts')
        .doc(postDoc.id)
        .delete();
      } catch(e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
      }
    }
  }
}