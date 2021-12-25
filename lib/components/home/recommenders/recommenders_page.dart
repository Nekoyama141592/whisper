// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/components/home/recommenders/components/post_cards.dart';
// model
import 'recommenders_model.dart';
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class RecommendersPage extends ConsumerWidget {
  
  const RecommendersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);
  
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final recommendersModel = watch(recommendersProvider);
    final commentsModel = watch(commentsProvider);
    final officialAdsensesModel = watch(officialAdsensesProvider); 
    final editPostInfoModel = watch(editPostInfoProvider);

    return recommendersModel.isLoading ?
    Loading()
    : JudgeScreen(
      list: recommendersModel.recommenderDocs,
      reload: () async {
        recommendersModel.startLoading();
        recommendersModel.getRecommenders();
        recommendersModel.endLoading();
      },
      content: PostCards(
        postDocs: recommendersModel.recommenderDocs, 
        route: () {
          routes.toPostShowPage(
            context,
            recommendersModel.speedNotifier,
            () async { await recommendersModel.speedControll(); },
            recommendersModel.currentSongMapNotifier, 
            recommendersModel.progressNotifier, 
            recommendersModel.seek, 
            recommendersModel.repeatButtonNotifier, 
            () { recommendersModel.onRepeatButtonPressed(); }, 
            recommendersModel.isFirstSongNotifier, 
            () { recommendersModel.onPreviousSongButtonPressed(); }, 
            recommendersModel.playButtonNotifier, 
            () { recommendersModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
            () { recommendersModel.pause(); }, 
            recommendersModel.isLastSongNotifier, 
            () { recommendersModel.onNextSongButtonPressed(); },
            () async {
              await commentsModel.init(context, recommendersModel.audioPlayer, recommendersModel.currentSongMapNotifier, mainModel, recommendersModel.currentSongMapNotifier.value['postId']);
            },
            () {
              recommendersModel.pause();
              editPostInfoModel.isEditing = true;
              editPostInfoModel.reload();
            },
            mainModel
          );
        },  
        progressNotifier: recommendersModel.progressNotifier, 
        seek: recommendersModel.seek, 
        currentSongMapNotifier: recommendersModel.currentSongMapNotifier ,
        playButtonNotifier: recommendersModel.playButtonNotifier, 
        play: () async { 
          recommendersModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); 
          await officialAdsensesModel.onPlayButtonPressed(context);
        }, 
        pause: () { recommendersModel.pause(); }, 
        currentUserDoc: mainModel.currentUserDoc,
        refreshController: recommendersModel.refreshController,
        onRefresh: () { recommendersModel.onRefresh(); },
        onLoading: () { recommendersModel.onLoading(); },
        isFirstSongNotifier: recommendersModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { recommendersModel.onPreviousSongButtonPressed(); },
        isLastSongNotifier: recommendersModel.isLastSongNotifier,
        onNextSongButtonPressed: () { recommendersModel.onNextSongButtonPressed(); },
        mainModel: mainModel,
        recommendersModel: recommendersModel,
      )
    );
  }
}

