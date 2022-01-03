// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
import 'package:whisper/posts/components/one_post_audio_window/one_post_audio_window.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
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
  Widget build(BuildContext context, ScopedReader watch) {
    
    final editPostInfoModel = watch(editPostInfoProvider); 
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);
    final CommentsModel commentsModel = watch(commentsProvider);
    final ReplysModel replysModel = watch(replysProvider);
    final OnePostModel onePostModel = watch(onePostProvider);
    final officialAdsensesModel = watch(officialAdsensesProvider); 

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
              CommentCard(comment: oneCommentModel.oneCommentMap, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel, currentSongMap: onePostModel.currentSongMapNotifier.value,),
              OnePostAudioWindow(
                route: () {
                  routes.toPostShowPage(
                    context: context,
                    speedNotifier: onePostModel.speedNotifier,
                    speedControll:  () async { await voids.setSpeed(audioPlayer: onePostModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: onePostModel.speedNotifier); },
                    currentSongMapNotifier: onePostModel.currentSongMapNotifier, 
                    progressNotifier: onePostModel.progressNotifier, 
                    seek: onePostModel.seek, 
                    repeatButtonNotifier: onePostModel.repeatButtonNotifier, 
                    onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: onePostModel.audioPlayer, repeatButtonNotifier: onePostModel.repeatButtonNotifier); }, 
                    isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
                    onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: onePostModel.audioPlayer); }, 
                    playButtonNotifier: onePostModel.playButtonNotifier, 
                    play: () async { await voids.play(context: context, audioPlayer: onePostModel.audioPlayer, mainModel: mainModel, postId: onePostModel.currentSongMapNotifier.value[postIdKey], officialAdsensesModel: officialAdsensesModel); }, 
                    pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                    isLastSongNotifier: onePostModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer); },
                    toCommentsPage:  () async {
                      await commentsModel.init(context, onePostModel.audioPlayer, onePostModel.currentSongMapNotifier, mainModel, onePostModel.currentSongMapNotifier.value[postIdKey]);
                    },
                    toEditingMode:  () {
                      voids.toEditPostInfoMode(audioPlayer: onePostModel.audioPlayer, editPostInfoModel: editPostInfoModel);
                    },
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: onePostModel.progressNotifier, 
                playButtonNotifier: onePostModel.playButtonNotifier, 
                seek: onePostModel.seek, 
                play: () async { await voids.play(context: context, audioPlayer: onePostModel.audioPlayer, mainModel: mainModel, postId: onePostModel.currentSongMapNotifier.value[postIdKey], officialAdsensesModel: officialAdsensesModel); }, 
                pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); }, 
                title: Text(
                  onePostModel.currentSongMapNotifier.value[titleKey],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0 ),
                ), 
                currentUserDoc: mainModel.currentUserDoc
              )
            ],
          ),
        ),
      ),
    );
  }
}