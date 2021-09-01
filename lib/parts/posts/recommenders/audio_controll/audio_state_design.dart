import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

import 'package:whisper/constants/routes.dart' as routes;
class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.recommendersProvider);
  final RecommendersModel recommendersProvider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // toShowPage
        routes.toRecommenderShowPage(context, recommendersProvider.currentSongDoc, recommendersProvider);
      },
      child: Container(
        height: 130,
        child: Column(
          children: [
            AudioControllButtons(recommendersProvider),
            AudioProgressBar(recommendersProvider),
            CurrentSongTitle(recommendersProvider)
          ],
        ),
      ),
    );
  }
}
