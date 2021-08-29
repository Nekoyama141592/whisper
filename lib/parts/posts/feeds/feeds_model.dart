import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:whisper/parts/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/parts/posts/notifiers/progress_notifier.dart';
import 'package:whisper/parts/posts/notifiers/repeat_button_notifier.dart';

final feedsProvider = ChangeNotifierProvider(
  (ref) => FeedsModel()
);

class FeedsModel extends ChangeNotifier {
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  late bool isPlaying;
  late AudioPlayer audioPlayer;

  // data
  late QuerySnapshot<Map<String, dynamic>> follows;
  late QuerySnapshot<Map<String, dynamic>> snapshots;
  int feedsCount = -1;
  final oneTimeReadCount = 2;
  bool isLoading = false;
  List<DocumentSnapshot> documentSnapshots = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<String> followUids = [];
  List<String> mutesUids = [];
  User? currentUser;

  void init() {
    isPlaying = false;
    audioPlayer = AudioPlayer();
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }
  
}