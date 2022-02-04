// material
import 'package:flutter/material.dart';
// components
import 'components/audio_progress_bar.dart';
import 'components/current_song_user_name.dart';
import 'components/current_song_title.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_window/components/audio_window_user_image.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/next_song_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/previous_song_button.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';

class AudioWindow extends StatelessWidget {
  
  AudioWindow({
    Key? key,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.whisperPost,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed,
    required this.mainModel
  }) : super(key: key);
  
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final Post whisperPost;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: route,
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(height/75.0),
          child: Column(
            children: [
              AudioProgressBar(progressNotifier: progressNotifier, seek: seek),
              Row(
                children: [
                  AudioWindowUserImage(whisperPost: whisperPost, mainModel: mainModel),
                  Expanded(
                    child: Column(
                      children: [
                        CurrentSongUserName(whisperPost: whisperPost),
                        CurrentSongTitle(whisperPost: whisperPost)
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PreviousSongButton(isFirstSongNotifier: isFirstSongNotifier, onPreviousSongButtonPressed: onPreviousSongButtonPressed),
                        PlayButton(playButtonNotifier: playButtonNotifier, play: play, pause: pause),
                        NextSongButton(isLastSongNotifier: isLastSongNotifier, onNextSongButtonPressed: onNextSongButtonPressed)
                      ],
                    ),
                    
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
