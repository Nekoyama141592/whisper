import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/posts_model.dart';

import 'package:whisper/parts/audio_controll/audio_controll_buttons.dart';
import 'package:whisper/parts/audio_controll/audio_progress_bar.dart';
import 'package:whisper/parts/audio_controll/current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  const AudioStateDesign({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AudioControllButtons(postsProvider: _postsProvider),
        AudioProgressBar(postsProvider: _postsProvider),
        CurrentSongTitle(postsProvider: _postsProvider)
      ],
    );
  }
}
