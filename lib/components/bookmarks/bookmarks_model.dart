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
import 'package:whisper/constants/enums.dart';
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
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);
  // enums
  final PostType postType = PostType.bookmarks;

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

  Future getNewBookmarks(List<dynamic> bookmarkedPostIds) async {
    
    if (bookmarkedPostIds.isNotEmpty) {
      await FirebaseFirestore.instance
      .collection('posts')
      .where('postId', whereIn: bookmarkedPostIds)
      .endBeforeDocument(posts.first)
      .limit(oneTimeReadCount)
      .get()
      .then((qshot) {
        voids.processNewPosts(qshot: qshot, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
      });
    }
  }


  Future getBookmarks (List<dynamic> bookmarkedPostIds) async {
    try{
      if (bookmarkedPostIds.isNotEmpty) {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('postId', whereIn: bookmarkedPostIds)
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          voids.processBasicPosts(qshot: qshot, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
        });
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> getOldBookmarks(List<dynamic> bookmarkedPostIds) async {
    try {
      if (bookmarkedPostIds.isEmpty) {
        await FirebaseFirestore.instance
        .collection('posts')
        .where('postId', whereIn: bookmarkedPostIds)
        .startAfterDocument(posts.last)
        .limit(oneTimeReadCount)
        .get()
        .then((qshot) {
          voids.processOldPosts(qshot: qshot, posts: posts, afterUris: afterUris, audioPlayer: audioPlayer, postType: postType, mutesUids: [], blocksUids: [], mutesIpv6s: [], blocksIpv6s: [], mutesPostIds: []);
        });
      }
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

}

