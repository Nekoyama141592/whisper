import 'package:flutter/material.dart';
import '../preservations_model.dart';
import 'package:whisper/constants/routes.dart' as routes;

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.preservationsProvider);
  final PreservationsModel preservationsProvider;
  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        routes.toPostShowPage(context, preservationsProvider.currentSongDoc);
      },
      child: Container(
        height: 130,
        child: Column(
          children: [
            AudioControllButtons(preservationsProvider),
            AudioProgressBar(preservationsProvider),
            CurrentSongTitle(preservationsProvider)
          ],
        ),
      ),
    );
  }
}