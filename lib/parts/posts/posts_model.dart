import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';
final postsProvider = ChangeNotifierProvider(
  (ref) => PostsModel()
); 
class PostsModel extends ChangeNotifier {
  // notifiers
  final feedsCurrentSongTitleNotifier = ValueNotifier<String>('');
  final recommendersCurrentSongTitleNotifier = ValueNotifier<String>('');
  late DocumentSnapshot feedsCurrentSongDoc;
  List<DocumentSnapshot> feedsCurrentSongDocs = [];
  late DocumentSnapshot recommendersCurrentSongDoc;
  List<DocumentSnapshot> recommendersCurrentSongDocs = [];
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late Uri song;
  late UriAudioSource source;
  late AudioPlayer feedsAudioPlayer;
  late AudioPlayer recommendersAudioPlayer;
  final List<AudioSource> afterUris = [];
  late ConcatenatingAudioSource playlist;
  // FirebaseAuth
  User? currentUser;
  // Cloud_Firestore
  late QuerySnapshot<Map<String, dynamic>> follows;
  late QuerySnapshot<Map<String, dynamic>> snapshots;
  final oneTimeReadCount = 2;
  int feedsCount = -1;
  int recommendersCount = -1;
  

  bool isLoading = false;
  List<DocumentSnapshot> feedDocuments = [];
  List<DocumentSnapshot> recommenderDocuments = [];
  List<String> followUids = [];
  List<String> mutesUids = [];
  //repost
  bool isReposted = false;
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  PostsModel() {
    init();
  }
  void init() async {
    startLoading();
    feedsAudioPlayer = AudioPlayer();
    recommendersAudioPlayer = AudioPlayer();
    setCurrentUser();
    await setFollowUids();
    await setMutesList();
    await getFeeds();
    await getRecommendes();
    listenForStates(feedsAudioPlayer);
    listenForStates(recommendersAudioPlayer);
    endLoading();
  }

  void startLoading () {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setCurrentUser()  {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void play(audioPlayer)  {
    audioPlayer.play();
    notifyListeners();
  }

  void pause(audioPlayer) {
    audioPlayer.pause();
    notifyListeners();
  }

  void seekInFeedsAudioPlayer(Duration position) {
    feedsAudioPlayer.seek(position);
  }
  
  void seekInRecommendersAudioPlayer(Duration position) {
    recommendersAudioPlayer.seek(position);
  }
  // showPage
  void onRepeatButtonPressed(audioPlayer) {
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

  void onPreviousSongButtonPressed(audioPlayer) {
    audioPlayer.seekToPrevious();
  }

  void onNextSongButtonPressed(audioPlayer) {
    audioPlayer.seekToNext();
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
  // muteList設定
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

  // getFeeds
  Future getFeeds() async {

    try{
      snapshots = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid',whereIn: followUids)
      .get();
      snapshots.docs.forEach((DocumentSnapshot doc) {
        feedDocuments.add(doc);
        song = Uri.parse(doc['audioURL']);
        source = AudioSource.uri(song, tag: doc);
        afterUris.add(source);
        playlist = ConcatenatingAudioSource(children: afterUris);
      });
      await feedsAudioPlayer.setAudioSource(playlist);
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // recommenders
  Future getRecommendes() async {
    final now = DateTime.now();
    final range = now.subtract(Duration(days: 5));
    
    try {

      if (recommendersCount == -1) {
        snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot doc) {
          recommenderDocuments.add(doc);
          song = Uri.parse(doc['audioURL']);
          source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
          playlist = ConcatenatingAudioSource(children: afterUris);
        });
        await recommendersAudioPlayer.setAudioSource(playlist);
      } else {
        snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        // .where('uid',whereNotIn: mutesUids)
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .startAfterDocument(recommenderDocuments[recommendersCount])
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot doc) {
          recommenderDocuments.add(doc);
        });
      }
      
      print(recommenderDocuments.length.toString() + "!!!!!!!!!");
      recommendersCount += oneTimeReadCount;
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

  void listenForStates(audioPlayer) {
    listenForChangesInPlayerState(audioPlayer);
    listenForChangesInPlayerPosition(audioPlayer);
    listenForChangesInBufferedPosition(audioPlayer);
    listenForChangesInTotalDuration(audioPlayer);
    listenForChangesInSequenceState(audioPlayer);
  }
  void listenForChangesInPlayerState(audioPlayer) {
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

  void listenForChangesInPlayerPosition(audioPlayer) {
    audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInBufferedPosition(audioPlayer) {
    audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void listenForChangesInTotalDuration(audioPlayer) {
    audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void listenForChangesInSequenceState(audioPlayer) {
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      // update current song doc
      final currentItem = sequenceState.currentSource;
        if (audioPlayer == feedsAudioPlayer) {
          feedsCurrentSongDoc = currentItem?.tag;
          final title = currentItem?.tag['title'];
          feedsCurrentSongTitleNotifier.value = title ?? '';
        } else {
          recommendersCurrentSongDoc = currentItem?.tag;
          final title = currentItem?.tag['title'];
          recommendersCurrentSongTitleNotifier.value = title ?? '';
        }
        notifyListeners();
      // update playlist
      final playlist = sequenceState.effectiveSequence;
      
      playlist.map((item) {
        if (audioPlayer == feedsAudioPlayer) {
          feedsCurrentSongDocs.add(item.tag);
        } else {
          recommendersCurrentSongDocs.add(item.tag);
        }
        notifyListeners();
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