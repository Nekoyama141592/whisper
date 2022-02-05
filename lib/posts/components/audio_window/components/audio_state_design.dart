// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/posts/components/audio_controll_buttons/audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// domain
import 'package:whisper/domain/post/post.dart';

class AudioStateDesign extends StatelessWidget {
  
  const AudioStateDesign({
    Key? key,
    required this.speedNotifier,
    required this.speedControll,
    required this.bookmarkedPostIds,
    required this.likePostIds,
    required this.currentWhisperPost,
    required this.progressNotifier,
    required this.seek,
    required this.repeatButtonNotifier,
    required this.onRepeatButtonPressed,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed
  }) : super(key: key);

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
  final List bookmarkedPostIds;
  final List likePostIds;
  final Post currentWhisperPost;
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
      
      child: Column(
        children: [
          AudioControllButtons(speedControll: speedControll,speedNotifier: speedNotifier,repeatButtonNotifier: repeatButtonNotifier, onRepeatButtonPressed: onRepeatButtonPressed, isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed, playButtonNotifier: playButtonNotifier, play: play, pause: pause, isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed),
          AudioProgressBar(progressNotifier: progressNotifier, seek: seek),
        ],
      ),
    );
  }
}