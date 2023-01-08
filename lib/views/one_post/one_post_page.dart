// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// costants
import 'package:whisper/constants/routes.dart' as routes;
// other_pages
import 'package:whisper/views/post_show_page/post_show_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/one_post/one_post_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class OnePostPage extends ConsumerWidget {

  OnePostPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);
    return Scaffold(
      body: PostShowPage(
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
        toCommentsPage: () => routes.toCommentsPage(context: context, audioPlayer: onePostModel.audioPlayer, currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel  ),
        toEditingMode: () => onePostModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel),
        postType: onePostModel.postType,
        mainModel: mainModel
      ),
    );
  }
}