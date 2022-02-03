// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
import 'package:whisper/posts/components/one_post_audio_window/one_post_audio_window.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

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
    final ReplysModel replysModel = ref.watch(replysProvider);
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final officialAdsensesModel = ref.watch(officialAdsensesProvider); 

    return Scaffold(
      body: oneCommentModel.isLoading ?
      SizedBox.shrink()
      : Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BackArrowButton(),
              CommentCard(whisperComment: oneCommentModel.oneWhisperComment, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value!,),
              OnePostAudioWindow(
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
                    play: () async { await voids.play(context: context, audioPlayer: onePostModel.audioPlayer, mainModel: mainModel, postId: onePostModel.currentWhisperPostNotifier.value!.postId, officialAdsensesModel: officialAdsensesModel); }, 
                    pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                    isLastSongNotifier: onePostModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer); },
                    toCommentsPage:  () async {
                      await commentsModel.init(context: context, audioPlayer: onePostModel.audioPlayer, whisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value! );
                    },
                    toEditingMode:  () {
                      voids.toEditPostInfoMode(audioPlayer: onePostModel.audioPlayer, editPostInfoModel: editPostInfoModel);
                    },
                    postType: onePostModel.postType,
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: onePostModel.progressNotifier, 
                playButtonNotifier: onePostModel.playButtonNotifier, 
                seek: onePostModel.seek, 
                play: () async { await voids.play(context: context, audioPlayer: onePostModel.audioPlayer, mainModel: mainModel, postId: onePostModel.currentWhisperPostNotifier.value!.postId, officialAdsensesModel: officialAdsensesModel); }, 
                pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                title: Text(
                  onePostModel.currentWhisperPostNotifier.value!.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0 ),
                ), 
                currentWhisperUser: mainModel.currentWhisperUser,
              )
            ],
          ),
        ),
      ),
    );
  }
}