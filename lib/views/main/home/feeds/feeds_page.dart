// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/views/main/home/feeds/components/post_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
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
    final isLoading = mainModel.isFeedLoading;
    final postDocs = mainModel.posts;

    return isLoading ?
    Loading()
    : PostCards(
      postDocs: postDocs,
      route: () {
        routes.toPostShowPage(
          context: context,
          speedNotifier: mainModel.speedNotifier,
          speedControll:  () async => await mainModel.speedControll(),
          currentWhisperPostNotifier: mainModel.currentWhisperPostNotifier,
          progressNotifier: mainModel.progressNotifier, 
          seek: mainModel.seek, 
          repeatButtonNotifier: mainModel.repeatButtonNotifier, 
          onRepeatButtonPressed:  () => mainModel.onRepeatButtonPressed(),
          isFirstSongNotifier: mainModel.isFirstSongNotifier, 
          onPreviousSongButtonPressed:  () => mainModel.onPreviousSongButtonPressed(),
          playButtonNotifier: mainModel.playButtonNotifier, 
          play: () => mainModel.play(),
          pause: () => mainModel.pause(),
          isLastSongNotifier: mainModel.isLastSongNotifier, 
          onNextSongButtonPressed:  () => mainModel.onNextSongButtonPressed(),
          toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: mainModel.audioPlayer, whisperPostNotifier: mainModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: mainModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
          toEditingMode:  () => mainModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel),
          postType: mainModel.postType,
          mainModel: mainModel
        ); 
      }, 
      progressNotifier: mainModel.progressNotifier,
      seek: mainModel.seek,
      currentWhisperPostNotifier: mainModel.currentWhisperPostNotifier,
      playButtonNotifier: mainModel.playButtonNotifier,
      play: () => mainModel.play(),
      pause: () => mainModel.pause(),
      refreshController: mainModel.refreshController,
      onRefresh: () async => await mainModel.onRefresh(),
      onLoading: () async => await mainModel.onLoading(),
      isFirstSongNotifier: mainModel.isFirstSongNotifier,
      onPreviousSongButtonPressed: () => mainModel.onPreviousSongButtonPressed(),
      isLastSongNotifier: mainModel.isLastSongNotifier,
      onNextSongButtonPressed: () =>mainModel.onNextSongButtonPressed(),
      mainModel: mainModel,
    );
  }

}
