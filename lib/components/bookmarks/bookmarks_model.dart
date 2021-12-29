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
    prefs = await SharedPreferences.getInstance();
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

  void seek(Duration position) {
    audioPlayer.seek(position);
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
      .endBeforeDocument(bookmarkedDocs.first)
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
      await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
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

}

