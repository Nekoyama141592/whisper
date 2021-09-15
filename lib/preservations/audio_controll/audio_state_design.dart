import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../preservations_model.dart';
import 'package:whisper/preservations/preservation_show_page.dart';

import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.currentUserDoc,this.preservationsProvider,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PreservationShowPage(currentUserDoc,preservationsProvider.currentSongDoc,preservationsProvider,preservatedPostIds,likedPostIds))
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