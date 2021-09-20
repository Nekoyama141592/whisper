import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.currentUserDoc,this.recommendersProvider,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      child: Column(
        children: [
          AudioControllButtons(recommendersProvider),
          AudioProgressBar(recommendersProvider),
          CurrentSongTitle(recommendersProvider)
        ],
      ),
    );
  }
}
