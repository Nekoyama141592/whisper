// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

class PostCards extends StatelessWidget {

  const PostCards({
    Key? key,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.currentWhisperPostNotifier,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed,
    required this.mainModel,
    required this.posts
  }) : super(key: key);

 
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<Post?> currentWhisperPostNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  final MainModel mainModel;
  final Widget posts;

  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        posts,
        ValueListenableBuilder<Post?>(
          valueListenable: currentWhisperPostNotifier,
          builder: (_,whisperPost,__) {
            return AudioWindow(
              route: route, 
              progressNotifier: progressNotifier, 
              seek: seek, 
              whisperPost: whisperPost!,
              playButtonNotifier: playButtonNotifier, 
              play: play, 
              pause: pause, 
              isFirstSongNotifier: isFirstSongNotifier,
              onPreviousSongButtonPressed: onPreviousSongButtonPressed,
              isLastSongNotifier: isLastSongNotifier,
              onNextSongButtonPressed: onNextSongButtonPressed,
              mainModel: mainModel,
            );
          }
        )
      ],
    );
  }
}