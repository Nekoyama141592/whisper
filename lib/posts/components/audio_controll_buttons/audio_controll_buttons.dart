// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/posts/components/audio_controll_buttons/components/next_song_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/previous_song_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/repeat_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/speed_controll_button.dart';
// notifiers
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class AudioControllButtons extends StatelessWidget {
  
  const AudioControllButtons({
    required this.speedNotifier,
    required this.speedControll,
    required this.repeatButtonNotifier,
    required this.onRepeatButtonPressed,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed
  });

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
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
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SpeedControllButton(speedNotifier: speedNotifier, speedControll: speedControll),
          RepeatButton(repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed),
          PreviousSongButton(isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed),
          PlayButton(playButtonNotifier: playButtonNotifier, play: play, pause: pause),
          NextSongButton(isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed)
        ],
      ),
    );
  }
}
