// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/posts/components/details/square_post_image.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_user_name.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/timestamp_display.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_screen.dart';

// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostShowPage extends ConsumerWidget {
  
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
  Widget build(BuildContext context, ScopedReader watch) {
    final editPostInfoModel = watch(editPostInfoProvider);
    final currentSongDoc = currentSongDocNotifier.value;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: editPostInfoModel.isEditing ?
        EditPostInfoScreen(currentUserDoc: currentUserDoc, currentSongDoc: currentSongDoc!, editPostInfoModel: editPostInfoModel)
        : Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    color: Theme.of(context).focusColor,
                    icon: Icon(Icons.keyboard_arrow_down),
                    onPressed: (){
                      Navigator.pop(context);
                    }, 
                  ),
                  SizedBox(width: size.width * 0.38),
                  TimestampDisplay(currentSongDocNotifier: currentSongDocNotifier)
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SquarePostImage(currentSongDocNotifier: currentSongDocNotifier),
                    CurrentSongUserName(currentSongDocNotifier: currentSongDocNotifier),
                    SizedBox(height: 10.0),
                    CurrentSongTitle(currentSongDocNotifier: currentSongDocNotifier),
                    SizedBox(height: 10.0),
                    PostButtons(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds, editPostInfoModel: editPostInfoModel),
                    SizedBox(height: 10.0),
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
            
          ],
        )
      ),
    );
  }
}