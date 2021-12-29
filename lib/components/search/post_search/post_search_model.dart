// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// package
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:algolia/algolia.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/components/search/constants/AlgoliaApplication.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

final postSearchProvider = ChangeNotifierProvider(
  (ref) => PostSearchModel()
);

class PostSearchModel extends ChangeNotifier{

  final Algolia algoliaApp = AlgoliaApplication.algolia;
  String searchTerm = '';
  bool isLoading = false;
   // just_audio
  late AudioPlayer audioPlayer;
  List<AudioSource> afterUris = [];
  List<Map<String,dynamic>> results = [];
   // notifiers
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  PostSearchModel() {
    init();
  }

  Future<void> init() async {
    audioPlayer = AudioPlayer();
    prefs = await SharedPreferences.getInstance();
    await voids.setSpeed(audioPlayer: audioPlayer,prefs: prefs,speedNotifier: speedNotifier);
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  bool isValidReadPost({ required Map<String,dynamic> map, required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required List<dynamic> mutesPostIds}) {
    return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: map) && !mutesPostIds.contains(map['postId']);
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

  Future mutePost(List<String> mutesPostIds,SharedPreferences prefs,int i,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final postId = post['postId'];
    mutesPostIds.add(postId);
    results.removeWhere((result) => result['postId'] == postId);
    await resetAudioPlayer(i);
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
    results.removeWhere((result) => result['uid'] == uid);
    await resetAudioPlayer(i);
  }

  Future search({required List<dynamic> mutesUids, required List<String> mutesPostIds, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required blocksIpv6s}) async {
    results = [];
    AlgoliaQuery query = algoliaApp.instance.index('Posts').query(searchTerm);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = querySnap.hits;
    hits.sort((a,b) => b.data['likes'].length.compareTo(a.data['likes'].length));
    hits.forEach((hit) {
      final Map<String,dynamic> map = hit.data;
      if ( isValidReadPost(map: map, mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, mutesPostIds: mutesPostIds) ) {
        results.add(map);
        Uri song = Uri.parse(map['audioURL']);
        UriAudioSource source = AudioSource.uri(song, tag: map);
        afterUris.add(source);
      }
    });
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist);
    }
  }

  Future operation({required List<dynamic> mutesUids, required List<String> mutesPostIds, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s}) async {
    startLoading();
    await search(mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s,);
    listenForStates();
    endLoading();
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

  void toEditPostInfoMode({ required EditPostInfoModel editPostInfoModel}) {
    pause();
    editPostInfoModel.isEditing = true;
    notifyListeners();
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
      // update current song map
      final currentItem = sequenceState.currentSource;
      final Map<String,dynamic> currentSongMap = currentItem?.tag;
      currentSongMapNotifier.value = currentSongMap;
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

  void onDeleteButtonPressed(BuildContext context,Map<String,dynamic> map,DocumentSnapshot currentUserDoc,int i) {
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
                await delete(context, map, currentUserDoc, i);
              },
            )
          ],
        );
      }
    );
  }


  Future delete(BuildContext context,Map<String,dynamic> map, DocumentSnapshot currentUserDoc,int i) async {
    if (currentUserDoc['uid'] != map['uid']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('あなたにはその権限がありません')));
    } else {
      try {
        AudioSource source = afterUris[i];
        afterUris.remove(source);
        results.remove(map);
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: i);
        }
        notifyListeners();
        await FirebaseFirestore.instance
        .collection('posts')
        .doc(map['postId'])
        .delete();
      } catch(e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('何らかのエラーが発生しました')));
      }
    }
  }

}