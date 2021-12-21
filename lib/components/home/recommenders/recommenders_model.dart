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
  List<dynamic> blockingUids = [];
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
    await setMutesAndBlocks();
    await getRecommenders();
    getReadPostIds();
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

  void getReadPostIds() {
    List<dynamic> readPosts = currentUserDoc['readPosts'];
    readPosts.forEach((readPost) {
      readPostIds.add(readPost['postId']);
    });
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

  Future resetAudioPlayer(int i) async {
    // Abstractions in post_futures.dart cause Range errors.
    AudioSource source = afterUris[i];
    afterUris.remove(source);
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist,initialIndex: i == 0 ? i :  i - 1);
    } 
  }

  Future mutePost(List<String> mutesPostIds,SharedPreferences prefs,int i,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final postId = post['postId'];
    mutesPostIds.add(postId);
    recommenderDocs.removeWhere((result) => result['postId'] == postId);
    await resetAudioPlayer(i);
    notifyListeners();
    await prefs.setStringList('mutesPostIds', mutesPostIds);
  }

  Future muteUser(List<dynamic> mutesUids,SharedPreferences prefs,int i,DocumentSnapshot currentUserDoc,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
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

  Future blockUser(DocumentSnapshot currentUserDoc,List<dynamic> blockingUids,int i,List<dynamic> mutesIpv6AndUids,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
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
    recommenderDocs.removeWhere((result) => result['uid'] == uid);
    await resetAudioPlayer(i);
  }
  
  Future onRefresh() async {
    await getNewRecommenders();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewRecommenders() async {

    final now = DateTime.now();
    final range = now.subtract(Duration(days: 5));

    QuerySnapshot<Map<String, dynamic>> newSnapshots = await FirebaseFirestore.instance
    .collection('posts')
    .orderBy('score', descending: true)
    .endBeforeDocument(recommenderDocs[0])
    .limit(oneTimeReadCount)
    .get();
    
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
     // Sort by oldest first
    docs.reversed;
     // Insert at the top
    docs.forEach((DocumentSnapshot? doc) {
      // if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !readPostIds.contains(doc['postId']) && doc['createdAt'].toDate().isAfter(range) ) {
        if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !mutesIpv6s.contains(doc['ipv6']) && doc['createdAt'].toDate().isAfter(range) ) {
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
    prefs = await SharedPreferences.getInstance();
    mutesUids = currentUserDoc['mutesUids'];
    mutesPostIds = prefs.getStringList('mutesPostIds') ?? [];
    blockingUids = currentUserDoc['blockingUids'];
    // mutesIpv6s
    final List<dynamic> mutesIpv6AndUids = currentUserDoc['mutesIpv6AndUids'];
    mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
      mutesIpv6s.add(mutesIpv6AndUid['ipv6']);
    });
  }

  Future getRecommenders() async {
    final now = DateTime.now();
    final range = now.subtract(Duration(days: 5));
    
    try {
      QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('score', descending: true)
      .limit(oneTimeReadCount)
      .get();
      snapshots.docs.forEach((DocumentSnapshot? doc) {
        // if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !readPostIds.contains(doc['postId']) && doc['createdAt'].toDate().isAfter(range) ) {
        if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !mutesIpv6s.contains(doc['ipv6']) && doc['createdAt'].toDate().isAfter(range) ) {
          
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
      final now = DateTime.now();
      final range = now.subtract(Duration(days: 5));
      QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
      .collection('posts')
      .orderBy('score', descending: true)
      .startAfterDocument(recommenderDocs.last)
      .limit(oneTimeReadCount)
      .get();
      final lastIndex = recommenderDocs.lastIndexOf(recommenderDocs.last);
      snapshots.docs.forEach((DocumentSnapshot? doc) {
        // if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !readPostIds.contains(doc['postId']) && doc['createdAt'].toDate().isAfter(range) ) {
        if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) && !mutesIpv6s.contains(doc['ipv6']) && doc['createdAt'].toDate().isAfter(range) ) {
          recommenderDocs.add(doc);
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
      // playlist.map((item) {
      //   currentSongDocs.add(item.tag);
      // });
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
    showCupertinoDialog(
      context: context, builder: (context) {
        return CupertinoAlertDialog(
          title: Text('投稿削除'),
          content: Text('一度削除したら、復元はできません。本当に削除しますか？'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Ok'),
              isDestructiveAction: true,
              onPressed: () async {
                await delete(context, postDoc, currentUserDoc, i);
              },
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
        recommenderDocs.remove(postDoc);
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