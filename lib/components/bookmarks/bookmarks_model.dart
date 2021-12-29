// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// model
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

final bookmarksProvider = ChangeNotifierProvider(
  (ref) => BookmarksModel()
);

class BookmarksModel extends ChangeNotifier {
  
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
  List<String> bookmarkedPostIds = [];
  List<DocumentSnapshot> bookmarkedDocs = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  BookmarksModel() {
    init();
  }
  
  void init() async {
    startLoading();
    audioPlayer = AudioPlayer();
    setCurrentUser();
    await setCurrentUserDoc();
    setBookmarkedPostIds();
    await getBookmarks(bookmarkedPostIds);
    await setPrefs();
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

  Future mutePost(List<String> mutesPostIds,SharedPreferences prefs,int i,Map<String,dynamic> post) async {
    // Abstractions in post_futures.dart cause Range errors.
    final postId = post['postId'];
    mutesPostIds.add(postId);
    bookmarkedDocs.removeWhere((result) => result['postId'] == postId);
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
    await voids.updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentUserDoc: currentUserDoc);
  }

  Future blockUser({ required List<dynamic> blocksUids, required DocumentSnapshot currentUserDoc, required List<dynamic> blocksIpv6AndUids, required int i, required Map<String,dynamic> post}) async {
    // Abstractions in post_futures.dart cause Range errors.
    final String uid = post['uid'];
    await removeTheUsersPost(uid, i);
    voids.addBlocksUidsAndBlocksIpv6AndUid(blocksIpv6AndUids: blocksIpv6AndUids,blocksUids: blocksUids,map: post);
    notifyListeners();
    await voids.updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: currentUserDoc);
  }

  Future removeTheUsersPost(String uid,int i) async {
    bookmarkedDocs.removeWhere((result) => result['uid'] == uid);
    await resetAudioPlayer(i);
  }

  Future onRefresh() async {
    await getNewBookmarks(bookmarkedPostIds);
    notifyListeners();
    refreshController.refreshCompleted();
  }

  Future getNewBookmarks(List<dynamic> bookmarkedPostIds) async {
    
    if (bookmarkedPostIds.isNotEmpty) {
      QuerySnapshot<Map<String, dynamic>>  newSnapshots = await FirebaseFirestore.instance
      .collection('posts')
      .where('postId', whereIn: bookmarkedPostIds)
      .endBeforeDocument(bookmarkedDocs[0])
      .limit(oneTimeReadCount)
      .get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = newSnapshots.docs;
      // Sort by oldest first
      docs.reversed;
      // Insert at the top
      docs.forEach((DocumentSnapshot? doc) {
        bookmarkedDocs.insert(0, doc!);
        Uri song = Uri.parse(doc['audioURL']);
        UriAudioSource source = AudioSource.uri(song, tag: doc);
        afterUris.insert(0, source);
      });
      if (afterUris.isNotEmpty) {
        ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
        await audioPlayer.setAudioSource(playlist);
      }
    }
  }

  Future onLoading() async {
    await getOldBookmarks(bookmarkedPostIds);
    refreshController.loadComplete();
    notifyListeners();
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

  void setBookmarkedPostIds() {
    List maps = currentUserDoc['bookmarks'];
    maps.sort((a,b) => b['createdAt'].compareTo(a['createdAt']));
    maps.forEach((map) {
      bookmarkedPostIds.add(map['postId']);
    });
    notifyListeners();
  }

  Future getBookmarks (List<dynamic> bookmarkedPostIds) async {
    try{
      if (bookmarkedPostIds.isNotEmpty) {
        QuerySnapshot<Map<String, dynamic>>  snapshots = await FirebaseFirestore.instance
        .collection('posts')
        .where('postId', whereIn: bookmarkedPostIds)
        .limit(oneTimeReadCount)
        .get();
        snapshots.docs.forEach((DocumentSnapshot? doc) {
          bookmarkedDocs.add(doc!);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist);
        }
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getOldBookmarks(List<dynamic> bookmarkedPostIds) async {
    try {
      if (bookmarkedPostIds.isEmpty) {
        QuerySnapshot<Map<String, dynamic>>  snapshots = await FirebaseFirestore.instance
        .collection('posts')
        .where('postId', whereIn: bookmarkedPostIds)
        .startAfterDocument(bookmarkedDocs.last)
        .limit(oneTimeReadCount)
        .get();
        final lastIndex = bookmarkedDocs.lastIndexOf(bookmarkedDocs.last);
        snapshots.docs.forEach((DocumentSnapshot? doc) {
          bookmarkedDocs.add(doc!);
          Uri song = Uri.parse(doc['audioURL']);
          UriAudioSource source = AudioSource.uri(song, tag: doc);
          afterUris.add(source);
        });
        if (afterUris.isNotEmpty) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: lastIndex);
        }  
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

  Future setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setSpeed() {
    speedNotifier.value = prefs.getDouble('speed') ?? 1.0;
    audioPlayer.setSpeed(speedNotifier.value);
  }

  void toEditPostInfoMode({ required EditPostInfoModel editPostInfoModel}) {
    pause();
    editPostInfoModel.isEditing = true;
    notifyListeners();
  }

  Future speedControll({ required SharedPreferences prefs}) async {
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
        bookmarkedDocs.remove(postDoc);
        if (afterUris.isNotEmpty || afterUris.length != 1 ) {
          ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
          await audioPlayer.setAudioSource(playlist,initialIndex: i - 1);
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

