// material
import 'package:flutter/material.dart';
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
  final currentSongDocNotifier = ValueNotifier<DocumentSnapshot?>(null);

  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  
  late AudioPlayer audioPlayer;
  final List<AudioSource> afterUris = [];
  // cloudFirestore
  List<String> recommenderPostIds = [];
  List<DocumentSnapshot> recommenderDocs = [];
  // block and mutes
  late SharedPreferences prefs;
  List<String> mutesUids = [];
  List<String> mutesPostIds = [];
  List<dynamic> blockingUids = [];

  // refresh
  int refreshIndex = defaultRefreshIndex;
  RefreshController refreshController = RefreshController(initialRefresh: false);

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

  Future setCurrentUserDoc() async {
    try{
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid',isEqualTo: currentUser!.uid)
      .limit(1)
      .get()
      .then((qshot) {
        currentUserDoc = qshot.docs[0];
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> initAudioPlayer(int i) async {
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
    await audioPlayer.setAudioSource(playlist,initialIndex: i);
  }
  
  Future onRefresh() async {
    audioPlayer = AudioPlayer();
    refreshIndex = defaultRefreshIndex;
    recommenderDocs = [];
    await getRecommenders();
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future onLoading() async {
    await getRecommenders();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future setMutesAndBlocks() async {
    prefs = await SharedPreferences.getInstance();
    mutesUids = prefs.getStringList('mutesUids') ?? [];
    mutesPostIds = prefs.getStringList('mutesPostIds') ?? [];
    blockingUids = currentUserDoc['blockingUids'];
  }

  Future getRecommenders() async {
    final now = DateTime.now();
    final range = now.subtract(Duration(days: 5));
    
    try {

      if (refreshIndex == defaultRefreshIndex) {
        QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot? doc) {
          if (!mutesUids.contains(doc!['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) ) {
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
      } else {
        QuerySnapshot<Map<String, dynamic>> snapshots =  await FirebaseFirestore.instance
        .collection('posts')
        .where('createdAt', isGreaterThanOrEqualTo: range)
        .orderBy('createdAt', descending: true)
        .orderBy('score', descending: true)
        .startAfterDocument(recommenderDocs[refreshIndex])
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot doc) {
          if (!mutesUids.contains(doc['uid']) && !mutesPostIds.contains(doc['postId']) && !blockingUids.contains(doc['uid']) ) {
            recommenderDocs.add(doc);
            Uri song = Uri.parse(doc['audioURL']);
            UriAudioSource source = AudioSource.uri(song, tag: doc);
            afterUris.add(source);
          }
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: refreshIndex);
        }
      }
      refreshIndex = afterUris.length + defaultRefreshIndex;
    } catch(e) {
      print(e.toString() + "!!!!!!!!!!!!!!!!!!!!!");
    }
    notifyListeners();
  }

  void play(List<dynamic> readPostIds,List<dynamic> readPosts,DocumentSnapshot currentUserDoc)  {
    audioPlayer.play();
    notifyListeners();
    audioPlayer.sequenceStateStream.listen((sequenceState) {
      final currentItem = sequenceState!.currentSource;
      final DocumentSnapshot? currentSongDoc = currentItem?.tag;
      final postId = currentSongDoc!['postId'];
      if (!readPostIds.contains(postId)) {
        final map = {
          'createdAt': Timestamp.now(),
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
    });
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