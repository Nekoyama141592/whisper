// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/views/main/home/feeds/components/post_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/models/posts/posts_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class FeedsPage extends ConsumerWidget {
  
  const FeedsPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  
  Widget build(BuildContext context, WidgetRef ref) {
    
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);
    final PostsModel postFutures = ref.watch(postsFeaturesProvider);

    final isLoading = mainModel.isFeedLoading;
    final postDocs = mainModel.posts;

    return isLoading ?
    Loading()
    : PostCards(
      postDocs: postDocs, 
      postFutures: postFutures,
      route: () {
        routes.toPostShowPage(
          context: context,
          speedNotifier: mainModel.speedNotifier,
          speedControll:  () async => await voids.speedControll(audioPlayer: mainModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: mainModel.speedNotifier),
          currentWhisperPostNotifier: mainModel.currentWhisperPostNotifier,
          progressNotifier: mainModel.progressNotifier, 
          seek: mainModel.seek, 
          repeatButtonNotifier: mainModel.repeatButtonNotifier, 
          onRepeatButtonPressed:  () => voids.onRepeatButtonPressed(audioPlayer: mainModel.audioPlayer, repeatButtonNotifier: mainModel.repeatButtonNotifier),
          isFirstSongNotifier: mainModel.isFirstSongNotifier, 
          onPreviousSongButtonPressed:  () => voids.onPreviousSongButtonPressed(audioPlayer: mainModel.audioPlayer),
          playButtonNotifier: mainModel.playButtonNotifier, 
          play: () => voids.play(audioPlayer: mainModel.audioPlayer),
          pause: () => voids.pause(audioPlayer: mainModel.audioPlayer),
          isLastSongNotifier: mainModel.isLastSongNotifier, 
          onNextSongButtonPressed:  () => voids.onNextSongButtonPressed(audioPlayer: mainModel.audioPlayer),
          toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: mainModel.audioPlayer, whisperPostNotifier: mainModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: mainModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
          toEditingMode:  () => voids.toEditPostInfoMode(audioPlayer: mainModel.audioPlayer, editPostInfoModel: editPostInfoModel),
          postType: mainModel.postType,
          mainModel: mainModel
        ); 
      }, 
      progressNotifier: mainModel.progressNotifier,
      seek: mainModel.seek,
      currentWhisperPostNotifier: mainModel.currentWhisperPostNotifier,
      playButtonNotifier: mainModel.playButtonNotifier,
      play: () => voids.play(audioPlayer: mainModel.audioPlayer),
      pause: () => voids.pause(audioPlayer: mainModel.audioPlayer),
      refreshController: mainModel.refreshController,
      onRefresh: () async => await mainModel.onRefresh(),
      onLoading: () async => await mainModel.onLoading(),
      isFirstSongNotifier: mainModel.isFirstSongNotifier,
      onPreviousSongButtonPressed: () => voids.onPreviousSongButtonPressed(audioPlayer: mainModel.audioPlayer),
      isLastSongNotifier: mainModel.isLastSongNotifier,
      onNextSongButtonPressed: () =>voids.onNextSongButtonPressed(audioPlayer: mainModel.audioPlayer),
      mainModel: mainModel,
    );
  }

}
