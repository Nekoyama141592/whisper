import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/posts_model.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

import 'package:whisper/constants/routes.dart' as routes;
class AudioStateDesign extends StatelessWidget {
  const AudioStateDesign({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        routes.toPostShowPage(context, _postsProvider.recommendersCurrentSongDoc,_postsProvider);
      },
      child: Container(
        height: 130,
        child: Column(
          children: [
            AudioControllButtons(postsProvider: _postsProvider),
            AudioProgressBar(postsProvider: _postsProvider),
            CurrentSongTitle(postsProvider: _postsProvider)
          ],
        ),
      ),
    );
  }
}
