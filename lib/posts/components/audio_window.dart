import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'audio_progress_bar.dart';
import 'current_song_post_id.dart';
import 'current_song_title.dart';
import '../audio_controll/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/audio_controll/notifiers/progress_notifier.dart';
import 'package:whisper/posts/audio_controll/notifiers/play_button_notifier.dart';

class AudioWindow extends StatelessWidget {
  AudioWindow(
    this.preservatedPostIds,
    this.likedPostIds,
    this.route,
    this.progressNotifier,
    this.seek,
    this.currentSongTitleNotifier,
    this.currentSongPostIdNotifier,
    this.playButtonNotifier,
    this.play,
    this.pause,
    this.currentUserDoc
  );
  
  final List preservatedPostIds;
  final List likedPostIds;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<String> currentSongTitleNotifier;
  final ValueNotifier<String> currentSongPostIdNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final DocumentSnapshot currentUserDoc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioWindowHeight = size.height * 0.12;
    return InkWell(
      onTap: route,
      child: Container(
        height: audioWindowHeight,
        child: Column(
          children: [
            AudioProgressBar(progressNotifier,seek),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                  ),
                  child: CircleAvatar(
                    radius: 20,
                    foregroundColor: Colors.blue,
                  ),
                ),
                Container(
                  width: size.width * 0.55,
                  child: Column(
                    children: [
                      CurrentSongTitle(currentSongTitleNotifier),
                      CurrentSongPostId(currentSongPostIdNotifier)
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PlayButton(playButtonNotifier,play,pause),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LikeButton(
                            currentUserDoc,
                            currentSongPostIdNotifier,
                            likedPostIds
                          ),
                          
                        ],
                      ),
                      
                    ],
                  ),
                  
                )
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}
