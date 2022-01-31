// material
import 'package:flutter/material.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';

final onePostProvider = ChangeNotifierProvider(
  (ref) => OnePostModel()
);

class OnePostModel extends ChangeNotifier {
  
  // basic
  bool isLoading = false;
  final PostType postType = PostType.onePost;
  // notifiers
  late AudioPlayer audioPlayer;
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final speedNotifier = ValueNotifier<double>(1.0);
  // just_audio
  List<AudioSource> afterUris = [];
  // post
  late DocumentSnapshot<Map<String,dynamic>> onePostDoc;
  List<DocumentSnapshot<Map<String,dynamic>>> onePostDocList = [];
  final currentSongMapNotifier = ValueNotifier<Map<String,dynamic>>({});
  String indexPostId = '';

  Future<bool> init({ required String postId, required DocumentReference<Map<String,dynamic>> postDocRef }) async {
    startLoading();
    if (indexPostId != postId) {
      onePostDocList = [];
      indexPostId = postId;
      onePostDoc = await postDocRef.get();
      onePostDocList.add(onePostDoc);
      currentSongMapNotifier.value = onePostDoc.data()!;
      // final post = fromMapToManyUpdatePost(manyUpdatePostMap: currentSongMapNotifier.value);
      final Post post = fromMapToPost(postMap: currentSongMapNotifier.value);
      Uri song = Uri.parse(post.audioURL);
      UriAudioSource audioSource = AudioSource.uri(song,tag: onePostDoc);
      audioPlayer = AudioPlayer();
      await audioPlayer.setAudioSource(audioSource);
      voids.listenForStates(audioPlayer: audioPlayer, playButtonNotifier: playButtonNotifier, progressNotifier: progressNotifier, currentSongMapNotifier: currentSongMapNotifier, isShuffleModeEnabledNotifier: isShuffleModeEnabledNotifier, isFirstSongNotifier: isFirstSongNotifier, isLastSongNotifier: isLastSongNotifier);
    }
    endLoading();
    return onePostDoc.exists;
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void seek(Duration position) {
    audioPlayer.seek(position);
  }

  
}