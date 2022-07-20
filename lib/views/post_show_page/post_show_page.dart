// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/posts/components/details/square_post_image.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_user_name.dart';
import 'package:whisper/views/post_show_page/components/timestamp_display.dart';
import 'package:whisper/views/edit_post_info/edit_post_info_page.dart';
// constants
import 'package:whisper/constants/enums.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/repeat_button_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class PostShowPage extends ConsumerWidget {
  
  const PostShowPage({
    Key? key,
    required this.speedNotifier,
    required this.speedControll,
    required this.currentWhisperPostNotifier,
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
    required this.postType,
    required this.mainModel,
  }) : super(key: key);

  final ValueNotifier<double> speedNotifier;
  final void Function()? speedControll;
  final ValueNotifier<Post?> currentWhisperPostNotifier;
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
  final PostType postType;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final editPostInfoModel = ref.watch(editPostInfoProvider);
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: false,
      body: ValueListenableBuilder<Post?>(
        valueListenable: currentWhisperPostNotifier,
        builder: (_,whisperPost,__) {
          return SafeArea(
            child: editPostInfoModel.isEditing ?
            EditPostInfoScreen(mainModel: mainModel, currentWhisperPost: currentWhisperPostNotifier.value!, editPostInfoModel: editPostInfoModel,)
            : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: defaultPadding(context: context)
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
                        Expanded(child: SizedBox()),
                        TimestampDisplay(whisperPost: whisperPost!)
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SquarePostImage(whisperPost: whisperPost),
                          CurrentSongUserName(whisperPost: whisperPost,mainModel: mainModel, ),
                          SizedBox(height: defaultPadding(context: context)),
                          CurrentSongTitle(whisperPost: whisperPost,),
                          SizedBox(height: defaultPadding(context: context)),
                          PostButtons(whisperPost: whisperPost, postType: postType, toCommentsPage: toCommentsPage, toEditingMode: toEditingMode,mainModel: mainModel, editPostInfoModel: editPostInfoModel),
                          SizedBox(height: defaultPadding(context: context)),
                          AudioStateDesign(
                            speedNotifier: speedNotifier,
                            speedControll: speedControll,
                            bookmarkedPostIds: mainModel.bookmarksPostIds,
                            likePostIds: mainModel.likePostIds,
                            currentWhisperPost: whisperPost,
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
          );
        }
      ),
    );
  }
}