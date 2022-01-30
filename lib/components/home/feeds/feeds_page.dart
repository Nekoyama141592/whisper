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
  
  Widget build(BuildContext context, WidgetRef ref) {
    
    final commentsModel = ref.watch(commentsProvider);
    final officialAdsensesModel = ref.watch(officialAdsensesProvider); 
    final editPostInfoModel = ref.watch(editPostInfoProvider);
    final isLoading = mainModel.isFeedLoading;
    final postDocs = mainModel.posts;

    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs,
      reload: () async {
        await mainModel.onReload(followingUids: mainModel.followingUids);
      },
      content: PostCards(
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: mainModel.speedNotifier,
            speedControll:  () async { await voids.speedControll(audioPlayer: mainModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: mainModel.speedNotifier); },
            currentSongMapNotifier: mainModel.currentSongMapNotifier, 
            progressNotifier: mainModel.progressNotifier, 
            seek: mainModel.seek, 
            repeatButtonNotifier: mainModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: mainModel.audioPlayer, repeatButtonNotifier: mainModel.repeatButtonNotifier); }, 
            isFirstSongNotifier: mainModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: mainModel.audioPlayer); }, 
            playButtonNotifier: mainModel.playButtonNotifier, 
            play: () async { 
              await voids.play(context: context, audioPlayer: mainModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: mainModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
            }, 
            pause: () { voids.pause(audioPlayer: mainModel.audioPlayer); }, 
            isLastSongNotifier: mainModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: mainModel.audioPlayer); },
            toCommentsPage:  () async {
              await commentsModel.init(context, mainModel.audioPlayer, mainModel.currentSongMapNotifier, mainModel, fromMapToPost(postMap: mainModel.currentSongMapNotifier.value).postId,);
            },
            toEditingMode:  () {
              voids.toEditPostInfoMode(audioPlayer: mainModel.audioPlayer, editPostInfoModel: editPostInfoModel);
            },
            postType: mainModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: mainModel.progressNotifier,
        seek: mainModel.seek,
        currentSongMapNotifier: mainModel.currentSongMapNotifier,
        playButtonNotifier: mainModel.playButtonNotifier,
        play: () async {
          await voids.play(context: context, audioPlayer: mainModel.audioPlayer, mainModel: mainModel, postId: fromMapToPost(postMap: mainModel.currentSongMapNotifier.value).postId, officialAdsensesModel: officialAdsensesModel);
        },
        pause: () {
          voids.pause(audioPlayer: mainModel.audioPlayer);
        }, 
        refreshController: mainModel.refreshController,
        onRefresh: () async { await mainModel.onRefresh(followingUids: mainModel.followingUids); },
        onLoading: () async { await mainModel.onLoading(followingUids: mainModel.followingUids ); },
        isFirstSongNotifier: mainModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { voids.onPreviousSongButtonPressed(audioPlayer: mainModel.audioPlayer); },
        isLastSongNotifier: mainModel.isLastSongNotifier,
        onNextSongButtonPressed: () { voids.onNextSongButtonPressed(audioPlayer: mainModel.audioPlayer); },
        mainModel: mainModel,
      )
    );
  }

}
