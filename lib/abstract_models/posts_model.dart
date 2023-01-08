// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whisper/constants/bools.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/domain/post/post.dart';
// domain
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';
// notifiers
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
// components
import 'package:whisper/details/positive_text.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:whisper/constants/doubles.dart';
// domain
import 'package:whisper/domain/like_post/like_post.dart';
import 'package:whisper/domain/post_like/post_like.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/mute_post/mute_post.dart';
import 'package:whisper/domain/post_mute/post_mute.dart';
import 'package:whisper/domain/post_report/post_report.dart';
import 'package:whisper/domain/bookmark_post/bookmark_post.dart';
import 'package:whisper/domain/post_bookmark/post_bookmark.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
// components
import 'package:whisper/details/report_contents_list_view.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/user_mute/user_mute.dart';

abstract class PostsModel extends ChangeNotifier {
  bool isLoading = false;
  // notifiers
  final currentWhisperPostNotifier = ValueNotifier<Post?>(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  AudioPlayer audioPlayer = AudioPlayer();
  List<AudioSource> afterUris = [];
  // cloudFirestore
  List<DocumentSnapshot<Map<String,dynamic>>> posts = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // speed
  late SharedPreferences prefs;
  final speedNotifier = ValueNotifier<double>(1.0);

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> setSpeed() async {
    speedNotifier.value = prefs.getDouble(speedPrefsKey) ?? 1.0;
    await audioPlayer.setSpeed(speedNotifier.value);
  }

  Future<void> speedControll() async {
    if (speedNotifier.value == 4.0) {
      speedNotifier.value = 1.0;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble(speedPrefsKey, speedNotifier.value);
    } else {
      speedNotifier.value += 0.5;
      await audioPlayer.setSpeed(speedNotifier.value);
      await prefs.setDouble(speedPrefsKey, speedNotifier.value);
    }
  }
  Future<void> resetAudioPlayer({ required int i }) async {
    // Abstractions in post_futures.dart cause Range errors.
    AudioSource source = afterUris[i];
    afterUris.remove(source);
    if (afterUris.isNotEmpty) {
      ConcatenatingAudioSource playlist = ConcatenatingAudioSource(children: afterUris);
      await audioPlayer.setAudioSource(playlist,initialIndex: i == 0 ? i :  i - 1);
    } 
  }
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
  void toEditPostInfoMode({required EditPostInfoModel editPostInfoModel}) {
    audioPlayer.pause();
    editPostInfoModel.isEditing = true;
    editPostInfoModel.reload();
  }

  void onPreviousSongButtonPressed() => audioPlayer.seekToPrevious();

  void onNextSongButtonPressed() => audioPlayer.seekToNext();

  void play() => audioPlayer.play();

  void pause() => audioPlayer.pause();

  void seek(Duration position) => audioPlayer.seek(position);

  void listenForStates() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration();
    listenForChangesInSequenceState();
  }
  void listenForStatesForAddPostModel() {
    listenForChangesInPlayerState();
    listenForChangesInPlayerPosition();
    listenForChangesInBufferedPosition();
    listenForChangesInTotalDuration(); 
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
      final Post currentWhisperPost = currentItem?.tag;
      currentWhisperPostNotifier.value = currentWhisperPost;
      // update playlist
      final playlist = sequenceState.effectiveSequence;
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
  }
}