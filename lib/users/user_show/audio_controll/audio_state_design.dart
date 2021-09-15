import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../user_show_model.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.currentUserDoc,this.userShowProvider,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  final UserShowModel userShowProvider;
  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // toUser show post show
        routes.toUserShowPostShowPage(context,currentUserDoc,userShowProvider.currentSongDoc, userShowProvider,preservatedPostIds,likedPostIds);
      },
      child: Container(
        height: 130,
        child: Column(
          children: [
            AudioControllButtons(userShowProvider),
            AudioProgressBar(userShowProvider),
            CurrentSongTitle(userShowProvider)
          ],
        ),
      ),
    );
  }
}