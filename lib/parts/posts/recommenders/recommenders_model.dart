import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

final recommendersProvider = ChangeNotifierProvider(
  (ref) => RecommendersModel()
);
class RecommendersModel extends ChangeNotifier {

  bool isLoading = false;
  User? currentUser;

  // notifiers
  final currentSongTitleNotifier = ValueNotifier<String>('');
  late DocumentSnapshot currentSongDoc;
  List<DocumentSnapshot> currentSongDocs = [];
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late Uri song;
  late UriAudioSource source;
  late AudioPlayer audioPlayer;
  final List<AudioSource> afterUris = [];
  late ConcatenatingAudioSource playlist;
  // cloudFirestore
  late QuerySnapshot<Map<String, dynamic>> follows;
  List<String> recommenderPostIds = [];
  List<String> followUids = [];
  List<String> mutesUids = [];
  List<DocumentSnapshot> recommenderDocs = [];
  late QuerySnapshot<Map<String, dynamic>> snapshots;
  final oneTimeReadCount = 2;
  int postsCount = -1;
  //repost
  bool isReposted = false;
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  RecommendersModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    // await
    await setFollowUids();
    await getRecommenders();
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
  // CloudFirestore
  Future setFollowUids() async {
    
    try {
      follows = await FirebaseFirestore.instance
      .collection('follows')
      .where('activeUserId', isEqualTo: currentUser!.uid)
      .get();
      follows.docs.forEach((DocumentSnapshot doc) {
        followUids.add(doc['passiveUserId']);
      });
      followUids.add(currentUser!.uid);
    } catch(e) {
      print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  Future setMutesList() async {
    try {
      await FirebaseFirestore.instance
      .collection('mutes')
      .where('activeUserId', isEqualTo: currentUser!.uid)
      .get()
      .then((snapshot){
        snapshot.docs.forEach((DocumentSnapshot doc) {
          mutesUids.add(doc['passiveUserId']);
        });
      } );

    } catch(e){
      print(e.toString());
    }
  }

  Future getRecommenders() async {
    final now = DateTime.now();
    final range = now.subtract(Duration(days: 5));
    
    try {

      if (postsCount == -1) {
        snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot doc) {
          recommenderDocs.add(doc);
          song = Uri.parse(doc['audioURL']);
          source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
          playlist = ConcatenatingAudioSource(children: afterUris);
        });
        await audioPlayer.setAudioSource(playlist);
      } else {
        snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        // .where('uid',whereNotIn: mutesUids)
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .startAfterDocument(recommenderDocs[postsCount])
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot doc) {
          recommenderDocs.add(doc);
        });
      }
      
      print(recommenderDocs.length.toString() + "!!!!!!!!!");
      postsCount += oneTimeReadCount;
    } catch(e) {
      print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!");
    }
    notifyListeners();
  }

  Future repost(DocumentSnapshot doc) async {
    try {
      await FirebaseFirestore.instance
      .collection('posts')
      .add({
        'uid': currentUser!.uid,
        'repostedPostId': doc.id,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        
      });
      print('repostTryPass!!!!');
      isReposted = true;
      notifyListeners();
    } catch(e) {
      print(e.toString() + "repostRepostRepost");
    }
  }

  void play()  {
    audioPlayer.play();
    notifyListeners();
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
      currentSongDoc = currentItem?.tag;
      final title = currentItem?.tag['title'];
      currentSongTitleNotifier.value = title ?? '';
      // update playlist
      final playlist = sequenceState.effectiveSequence;
      playlist.map((item) {
        currentSongDocs.add(item.tag);
      });
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
}