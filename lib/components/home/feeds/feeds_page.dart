// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
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
    final postDocs = feedsModel.feedDocs;

    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs,
      reload: () async {
        feedsModel.startLoading();
        await feedsModel.getFeeds();
        feedsModel.endLoading();
      },
      content: PostCards(
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: feedsModel.speedNotifier,
            speedControll:  () async { feedsModel.speedControll(prefs: mainModel.prefs); },
            currentSongMapNotifier: feedsModel.currentSongMapNotifier, 
            progressNotifier: feedsModel.progressNotifier, 
            seek: feedsModel.seek, 
            repeatButtonNotifier: feedsModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { feedsModel.onRepeatButtonPressed(); }, 
            isFirstSongNotifier: feedsModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { feedsModel.onPreviousSongButtonPressed(); }, 
            playButtonNotifier: feedsModel.playButtonNotifier, 
            play: () async { 
              await voids.play(audioPlayer: feedsModel.audioPlayer, mainModel: mainModel, postId: feedsModel.currentSongMapNotifier.value['postId'] );
            }, 
            pause: () { voids.pause(audioPlayer: feedsModel.audioPlayer); }, 
            isLastSongNotifier: feedsModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { feedsModel.onNextSongButtonPressed(); },
            toCommentsPage:  () async {
              await commentsModel.init(context, feedsModel.audioPlayer, feedsModel.currentSongMapNotifier, mainModel, feedsModel.currentSongMapNotifier.value['postId']);
            },
            toEditingMode:  () {
              feedsModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel);
            },
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: feedsModel.progressNotifier, 
        seek: feedsModel.seek, 
        currentSongMapNotifier: feedsModel.currentSongMapNotifier ,
        playButtonNotifier: feedsModel.playButtonNotifier, 
        play: () async { 
          feedsModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); 
          await officialAdsensesModel.onPlayButtonPressed(context);
        }, 
        pause: () { feedsModel.pause(); }, 
        currentUserDoc: mainModel.currentUserDoc,
        refreshController: feedsModel.refreshController,
        onRefresh: () { feedsModel.onRefresh(); },
        onLoading: () { feedsModel.onLoading();},
        isFirstSongNotifier: feedsModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { feedsModel.onPreviousSongButtonPressed(); },
        isLastSongNotifier: feedsModel.isLastSongNotifier,
        onNextSongButtonPressed: () { feedsModel.onNextSongButtonPressed(); },
        mainModel: mainModel,
        feedsModel: feedsModel,
      )
    );
  }

}
