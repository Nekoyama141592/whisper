import 'package:flutter/material.dart';

import 'package:whisper/posts/components/audio_controll_buttons/components/next_song_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/previous_song_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/repeat_button.dart';

import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class AudioControllButtons extends StatelessWidget {
  
  AudioControllButtons(
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
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          RepeatButton(repeatButtonNotifier,onRepeatButtonPressed),
          PreviousSongButton(isFirstSongNotifier,onPreviousSongButtonPressed),
          PlayButton(playButtonNotifier,play,pause),
          NextSongButton(isLastSongNotifier,onNextSongButtonPressed)
        ],
      ),
    );
  }
}
