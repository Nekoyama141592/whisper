// material
import 'package:flutter/material.dart';
// package
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
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostShowPage extends ConsumerWidget {
  
  const PostShowPage({
    Key? key,
    required this.speedNotifier,
    required this.speedControll,
    required this.currentSongMapNotifier,
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
    required this.onNextSongButtonPressed,
    required this.toCommentsPage,
    required this.toEditingMode,
    required this.mainModel,
  }) : super(key: key);

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
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
  final void Function()? toCommentsPage;
  final void Function()? toEditingMode;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final editPostInfoModel = watch(editPostInfoProvider);
    final currentSongMap = currentSongMapNotifier.value;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        child: editPostInfoModel.isEditing ?
        EditPostInfoScreen(mainModel: mainModel, currentSongMap: currentSongMap, editPostInfoModel: editPostInfoModel)
        : SingleChildScrollView(
          child: Column(
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
                    TimestampDisplay(currentSongMapNotifier: currentSongMapNotifier)
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SquarePostImage(currentSongMapNotifier: currentSongMapNotifier),
                      CurrentSongUserName(currentSongMapNotifier: currentSongMapNotifier),
                      SizedBox(height: 10.0),
                      CurrentSongTitle(currentSongMapNotifier: currentSongMapNotifier),
                      SizedBox(height: 10.0),
                      PostButtons(currentSongMapNotifier: currentSongMapNotifier, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode,mainModel: mainModel, editPostInfoModel: editPostInfoModel),
                      SizedBox(height: 10.0),
                      AudioStateDesign(
                        speedNotifier: speedNotifier,
                        speedControll: speedControll,
                        bookmarkedPostIds: mainModel.bookmarksPostIds,
                        likePostIds: mainModel.likePostIds,
                        currentSongMapNotifier: currentSongMapNotifier,
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
          ),
        )
      ),
    );
  }
}