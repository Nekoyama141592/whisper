import 'package:flutter/material.dart';

import '../../audio_controll_buttons/audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

import 'package:whisper/posts/notifiers/progress_notifier.dart';

import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class AudioStateDesign extends StatelessWidget {
  
  AudioStateDesign(
    this.preservatedPostIds,
    this.likedPostIds,
    this.currentSongTitleNotifier,
    this.progressNotifier,
    this.seek,
    this.repeatButtonNotifier,
    this.onRepeatButtonPressed,
    this.isFirstSongNotifier,
    this.onPreviousSongButtonPressed,
    this.playButtonNotifier,
    this.play,
    this.pause,
    this.isLastSongNotifier,
    this.onNextSongButtonPressed
  );
  
  final List preservatedPostIds;
  final List likedPostIds;
  final ValueNotifier<String> currentSongTitleNotifier;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final RepeatButtonNotifier repeatButtonNotifier;
  final void Function()? onRepeatButtonPressed;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()?  onPreviousSongButtonPressed;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        children: [
          AudioControllButtons(
            repeatButtonNotifier,
            onRepeatButtonPressed,
            isFirstSongNotifier,
            onPreviousSongButtonPressed,
            playButtonNotifier,
            play,
            pause,
            isLastSongNotifier,
            onNextSongButtonPressed
          ),
          AudioProgressBar(progressNotifier,seek),
          CurrentSongTitle(currentSongTitleNotifier)
        ],
      ),
    );
  }
}