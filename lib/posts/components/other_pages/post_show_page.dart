// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/comments/comments.dart';
import 'package:whisper/posts/components/details/square_post_image.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';

class PostShowPage extends StatelessWidget {
  
  const PostShowPage({
    Key? key,
    required this.likedPostIds,
    required this.bookmarkedPostIds,
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.progressNotifier,
    required this.seek,
    required this.repeatButtonNotifier,
    required this.onRepeatButtonPressed,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed
  }) : super(key: key);

  final List likedPostIds;
  final List bookmarkedPostIds;
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final RepeatButtonNotifier repeatButtonNotifier;
  final void Function()? onRepeatButtonPressed;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()?  onPreviousSongButtonPressed;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                padding: EdgeInsets.symmetric(
                  vertical: 20,
                ),
                color: Theme.of(context).focusColor,
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: (){
                  Navigator.pop(context);
                }, 
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SquarePostImage(currentSongDocNotifier: currentSongDocNotifier),
                    Center(
                      child: CurrentSongPostId(currentSongDocNotifier: currentSongDocNotifier)
                    ),
                    Center(
                      child: CurrentSongTitle(currentSongDocNotifier: currentSongDocNotifier)
                    ),
                    PostButtons(currentUserDoc, currentSongDocNotifier, bookmarkedPostIds, likedPostIds),
                    AudioStateDesign(
                      preservatedPostIds: bookmarkedPostIds,
                      likedPostIds: likedPostIds,
                      currentSongDocNotifier: currentSongDocNotifier,
                      progressNotifier: progressNotifier,
                      seek: seek,
                      repeatButtonNotifier: repeatButtonNotifier,
                      onRepeatButtonPressed: onRepeatButtonPressed,
                      isFirstSongNotifier: isFirstSongNotifier,
                      onPreviousSongButtonPressed: onPreviousSongButtonPressed,
                      playButtonNotifier: playButtonNotifier,
                      play: play,
                      pause: pause,
                      isLastSongNotifier: isLastSongNotifier,
                      onNextSongButtonPressed: onNextSongButtonPressed,
                    ),
                    
                  ],
                ),
              ),
            ),
            // comments
          ],
        )
      ),
    );
  }
}