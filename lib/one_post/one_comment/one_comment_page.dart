// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/comments/components/comment_card.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/replies/replys_model.dart';
import 'package:whisper/comments/comments_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';
import 'package:whisper/official_advertisements/official_advertisement_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';
// main.dart
import 'package:whisper/main.dart';

class OneCommentPage extends ConsumerWidget {
  
  OneCommentPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final editPostInfoModel = ref.watch(editPostInfoProvider); 
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final RepliesModel replysModel = ref.watch(repliesProvider);
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);
    final officialAdsensesModel = ref.watch(officialAdvertisementsProvider); 

    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: oneCommentModel.isLoading ?
        SizedBox.shrink()
        : Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BackArrowButton(),
                CommentCard(i:0, whisperComment: oneCommentModel.oneWhisperComment, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel, ),
                AudioWindow(
                  route: () {
                    routes.toPostShowPage(
                      context: context,
                      speedNotifier: onePostModel.speedNotifier,
                      speedControll:  () async { await voids.setSpeed(audioPlayer: onePostModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: onePostModel.speedNotifier); },
                      currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, 
                      progressNotifier: onePostModel.progressNotifier, 
                      seek: onePostModel.seek, 
                      repeatButtonNotifier: onePostModel.repeatButtonNotifier, 
                      onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: onePostModel.audioPlayer, repeatButtonNotifier: onePostModel.repeatButtonNotifier); }, 
                      isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
                      onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: onePostModel.audioPlayer); }, 
                      playButtonNotifier: onePostModel.playButtonNotifier, 
                      play: () { voids.play(audioPlayer: onePostModel.audioPlayer,officialAdvertisement: officialAdsensesModel); }, 
                      pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                      isLastSongNotifier: onePostModel.isLastSongNotifier, 
                      onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer); },
                      toCommentsPage:  () async {
                        await commentsModel.init(context: context, audioPlayer: onePostModel.audioPlayer, whisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel );
                      },
                      toEditingMode:  () {
                        voids.toEditPostInfoMode(audioPlayer: onePostModel.audioPlayer, editPostInfoModel: editPostInfoModel);
                      },
                      postType: onePostModel.postType,
                      mainModel: mainModel
                    ); 
                  }, 
                  progressNotifier: onePostModel.progressNotifier, 
                  seek: onePostModel.seek, 
                  whisperPost: onePostModel.currentWhisperPostNotifier.value!, 
                  playButtonNotifier: onePostModel.playButtonNotifier, 
                  play: () { voids.play(audioPlayer: onePostModel.audioPlayer,officialAdvertisement: officialAdsensesModel); }, 
                  pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                  isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
                  onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: onePostModel.audioPlayer); }, 
                  isLastSongNotifier: onePostModel.isLastSongNotifier, 
                  onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer); },
                  mainModel: mainModel
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}