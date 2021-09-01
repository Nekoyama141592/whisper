import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';


class AudioStateDesign extends StatelessWidget {
  
  AudioStateDesign(this.feedsProvider,this.preservatedPostIds,this.likedPostIds);
  final FeedsModel feedsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        children: [
          AudioControllButtons(feedsProvider),
          AudioProgressBar(feedsProvider),
          CurrentSongTitle(feedsProvider)
        ],
      ),
    );
  }
}
