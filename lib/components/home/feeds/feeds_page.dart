// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/home/feeds/components/post_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/home/feeds/feeds_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class FeedsPage extends ConsumerWidget {
  
  const FeedsPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override
  
  Widget build(BuildContext context, ScopedReader watch) {
    
    final feedsModel = watch(feedsProvider);
    final commentsModel = watch(commentsProvider);
    final officialAdsensesModel = watch(officialAdsensesProvider); 
    final editPostInfoModel = watch(editPostInfoProvider);
    final isLoading = feedsModel.isLoading;
    final postDocs = feedsModel.posts;

    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs,
      reload: () async {
        await feedsModel.onReload(followingUids: mainModel.followingUids);
      },
      content: PostCards(
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: feedsModel.speedNotifier,
            speedControll:  () async { await voids.speedControll(audioPlayer: feedsModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: feedsModel.speedNotifier); },
            currentSongMapNotifier: feedsModel.currentSongMapNotifier, 
            progressNotifier: feedsModel.progressNotifier, 
            seek: feedsModel.seek, 
            repeatButtonNotifier: feedsModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: feedsModel.audioPlayer, repeatButtonNotifier: feedsModel.repeatButtonNotifier); }, 
            isFirstSongNotifier: feedsModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: feedsModel.audioPlayer); }, 
            playButtonNotifier: feedsModel.playButtonNotifier, 
            play: () async { 
              await voids.play(context: context, audioPlayer: feedsModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: feedsModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
            }, 
            pause: () { voids.pause(audioPlayer: feedsModel.audioPlayer); }, 
            isLastSongNotifier: feedsModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: feedsModel.audioPlayer); },
            toCommentsPage:  () async {
              await commentsModel.init(context, feedsModel.audioPlayer, feedsModel.currentSongMapNotifier, mainModel, fromMapToPost(postMap: feedsModel.currentSongMapNotifier.value).postId,);
            },
            toEditingMode:  () {
              voids.toEditPostInfoMode(audioPlayer: feedsModel.audioPlayer, editPostInfoModel: editPostInfoModel);
            },
            postType: feedsModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: feedsModel.progressNotifier,
        seek: feedsModel.seek,
        currentSongMapNotifier: feedsModel.currentSongMapNotifier,
        playButtonNotifier: feedsModel.playButtonNotifier,
        play: () async {
          await voids.play(context: context, audioPlayer: feedsModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: feedsModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
        },
        pause: () {
          voids.pause(audioPlayer: feedsModel.audioPlayer);
        }, 
        refreshController: feedsModel.refreshController,
        onRefresh: () async { await feedsModel.onRefresh(followingUids: mainModel.followingUids); },
        onLoading: () async { await feedsModel.onLoading(followingUids: mainModel.followingUids ); },
        isFirstSongNotifier: feedsModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { voids.onPreviousSongButtonPressed(audioPlayer: feedsModel.audioPlayer); },
        isLastSongNotifier: feedsModel.isLastSongNotifier,
        onNextSongButtonPressed: () { voids.onNextSongButtonPressed(audioPlayer: feedsModel.audioPlayer); },
        mainModel: mainModel,
        feedsModel: feedsModel,
      )
    );
  }

}
