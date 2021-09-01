import 'package:flutter/material.dart';

import '../user_show_model.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'audio_controll_buttons.dart';
import 'audio_progress_bar.dart';
import 'current_song_title.dart';

class AudioStateDesign extends StatelessWidget {
  AudioStateDesign(this.userShowProvider,this.preservatedPostIds);
  final List preservatedPostIds;
  final UserShowModel userShowProvider;
  @override  
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // toUser show post show
        routes.toUserShowPostShowPage(context, userShowProvider.currentSongDoc, userShowProvider,preservatedPostIds);
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