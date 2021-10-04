// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/counts.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final userShowProvider = ChangeNotifierProvider(
  (ref) => UserShowModel()
);

class UserShowModel extends ChangeNotifier {

  bool isLoading = false;
  User? currentUser;
  
  // notifiers
  final currentSongDocNotifier = ValueNotifier<DocumentSnapshot?>(null);

  List<DocumentSnapshot> currentSongDocs = [];
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // just_audio
  late AudioPlayer audioPlayer;
  final List<AudioSource> afterUris = [];
  // cloudFirestore
  List<String> postIds = [];
  List<DocumentSnapshot> postDocs = [];
  // refresh
  int refreshIndex = defaultRefreshIndex;
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // Edit profile
  bool isEditing = false;
  String userName = '';
  String description = '';
  // afterEdit
  bool isEdited = false;
  
  UserShowModel() {
    init();
  }

  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await getPosts();
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

  void reload() {
    notifyListeners();
  }

  Future onRefresh() async {
    refreshIndex = defaultRefreshIndex;
    postDocs = [];
    await getPosts();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future onLoading() async {
    await getPosts();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future getPosts() async {
    try {
      if (refreshIndex == defaultRefreshIndex) {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('uid',isEqualTo: currentUser!.uid)
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          qshot.docs.forEach((DocumentSnapshot? doc) {
            postDocs.add(doc!);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          });
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist);
        }
      } else {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('uid',isEqualTo: currentUser!.uid)
        .startAfterDocument(postDocs[refreshIndex])
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          qshot.docs.forEach((DocumentSnapshot? doc) {
            postDocs.add(doc!);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          });
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: refreshIndex);
          refreshIndex += oneTimeReadCount;
        }
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
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
      final DocumentSnapshot? currentSongDoc = currentItem?.tag;
      currentSongDocNotifier.value = currentSongDoc;
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

  void onEditButtonPressed(DocumentSnapshot currentUserDoc) {
    userName = currentUserDoc['userName'];
    description = currentUserDoc['description'];
    isEditing = true;
    notifyListeners();
  }

  Future updateUserInfo(DocumentSnapshot currentUserDoc) async {
    try {
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'userName': userName,
        'updatedAt': Timestamp.now(),
        'description': description,
      });
      
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
  }

  Future onSaveButtonPressed(BuildContext context,DocumentSnapshot currentUserDoc) async {
    updateUserInfo(currentUserDoc);
    isEditing = false;
    isEdited = true;
    notifyListeners();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('snackbar'),
        duration: const Duration(seconds: 3),
      )
    );
  }
  
}