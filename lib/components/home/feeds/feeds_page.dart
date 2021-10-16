// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/home/feeds/components/post_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/home/feeds/feeds_model.dart';
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
    final editPostInfoModel = watch(editPostInfoProvider);
    final isLoading = feedsModel.isLoading;
    final postDocs = feedsModel.feedDocs;

    return isLoading ?
    Loading()
    : JudgeScreen(
      list: postDocs, 
      content: PostCards(
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context, 
            feedsModel.speedNotifier,
            () async { feedsModel.speedControll(); },
            feedsModel.currentSongDocNotifier, 
            feedsModel.progressNotifier, 
            feedsModel.seek, 
            feedsModel.repeatButtonNotifier, 
            () { feedsModel.onRepeatButtonPressed(); }, 
            feedsModel.isFirstSongNotifier, 
            () { feedsModel.onPreviousSongButtonPressed(); }, 
            feedsModel.playButtonNotifier, 
            () { feedsModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
            () { feedsModel.pause(); }, 
            feedsModel.isLastSongNotifier, 
            () { feedsModel.onNextSongButtonPressed(); },
            () {
              feedsModel.pause();
              routes.toCommentsPage(context, feedsModel.currentSongDocNotifier, mainModel);
            },
            () {
              feedsModel.pause();
              editPostInfoModel.isEditing = true;
              editPostInfoModel.reload();
            },
            mainModel
          );
        }, 
        progressNotifier: feedsModel.progressNotifier, 
        seek: feedsModel.seek, 
        currentSongDocNotifier: feedsModel.currentSongDocNotifier ,
        playButtonNotifier: feedsModel.playButtonNotifier, 
        play: () { feedsModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
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
