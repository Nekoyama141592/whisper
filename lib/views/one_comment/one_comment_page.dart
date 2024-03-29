// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/back_arrow_button.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/views/comments/components/comment_card.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/one_post/one_post_model.dart';
import 'package:whisper/models/replies/replies_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/models/one_comment/one_comment_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class OneCommentPage extends ConsumerWidget {
  
  OneCommentPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider); 
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final RepliesModel replysModel = ref.watch(repliesProvider);
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);

    return Scaffold(
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
              CommentCard(i:0, whisperPostComment: oneCommentModel.oneWhisperComment,commentDoc: oneCommentModel.oneCommentDoc, commentsModel: commentsModel, replysModel: replysModel, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel, ),
              AudioWindow(
                route: () {
                  routes.toPostShowPage(
                    context: context,
                    speedNotifier: onePostModel.speedNotifier,
                    speedControll:  () async => await onePostModel.setSpeed(),
                    currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, 
                    progressNotifier: onePostModel.progressNotifier, 
                    seek: onePostModel.seek, 
                    repeatButtonNotifier: onePostModel.repeatButtonNotifier, 
                    onRepeatButtonPressed:  () => onePostModel.onRepeatButtonPressed(),
                    isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
                    onPreviousSongButtonPressed:  () => onePostModel.onPreviousSongButtonPressed(),
                    playButtonNotifier: onePostModel.playButtonNotifier, 
                    play: () => onePostModel.play(),
                    pause: () => onePostModel.pause(),
                    isLastSongNotifier: onePostModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () => onePostModel.onNextSongButtonPressed(),
                    toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: onePostModel.audioPlayer, whisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: onePostModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
                    toEditingMode:  () => onePostModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel),
                    postType: onePostModel.postType,
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: onePostModel.progressNotifier, 
                seek: onePostModel.seek, 
                whisperPost: onePostModel.currentWhisperPostNotifier.value!, 
                playButtonNotifier: onePostModel.playButtonNotifier, 
                play: () => onePostModel.play(),
                pause: () => onePostModel.pause(),
                isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
                onPreviousSongButtonPressed:  () => onePostModel.onPreviousSongButtonPressed(),
                isLastSongNotifier: onePostModel.isLastSongNotifier, 
                onNextSongButtonPressed:  () => onePostModel.onNextSongButtonPressed(),
                mainModel: mainModel
              )
            ],
          ),
        ),
      ),
    );
  }
}