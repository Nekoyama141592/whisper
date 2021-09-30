// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'components/audio_progress_bar.dart';
import 'components/current_song_post_id.dart';
import 'components/current_song_title.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
import 'package:whisper/posts/components/audio_window/components/audio_window_user_image.dart';

class AudioWindow extends StatelessWidget {
  
  AudioWindow(
    this.preservatedPostIds,
    this.likedPostIds,
    this.route,
    this.progressNotifier,
    this.seek,
    this.currentSongTitleNotifier,
    this.currentSongPostIdNotifier,
    this.currentSongUserImageURLNotifier,
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
  final ValueNotifier<String> currentSongUserImageURLNotifier;
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
                AudioWindowUserImage(currentSongUserImageURLNotifier: currentSongUserImageURLNotifier),
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
