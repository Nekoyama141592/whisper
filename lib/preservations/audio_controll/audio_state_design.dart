import 'package:flutter/material.dart';
import '../preservations_model.dart';
import 'package:whisper/preservations/preservation_show_page.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.preservationsProvider,this.preservatedPostIds);
  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreservationShowPage(preservationsProvider.currentSongDoc,preservationsProvider,preservatedPostIds))
        );
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