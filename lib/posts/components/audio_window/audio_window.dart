// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'components/audio_progress_bar.dart';
import 'components/current_song_post_id.dart';
import 'components/current_song_title.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/audio_controll_buttons/components/play_button.dart';
import 'package:whisper/posts/components/audio_window/components/audio_window_user_image.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class AudioWindow extends StatelessWidget {
  
  AudioWindow({
    Key? key,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.currentSongDocNotifier,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.currentUserDoc
  }) : super(key: key);
  
  final List bookmarkedPostIds;
  final List likedPostIds;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
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
            AudioProgressBar(progressNotifier: progressNotifier, seek: seek),
            Row(
              children: [
                AudioWindowUserImage(currentSongDocNotifier: currentSongDocNotifier),
                Container(
                  width: size.width * 0.55,
                  child: Column(
                    children: [
                      CurrentSongTitle(currentSongDocNotifier: currentSongDocNotifier,),
                      CurrentSongPostId(currentSongDocNotifier: currentSongDocNotifier)
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
                          LikeButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, likedPostIds: likedPostIds)
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
