// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// costants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/domain/post/post.dart';
// other_pages
import 'package:whisper/posts/components/other_pages/post_show/post_show_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

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
    final PostFutures postFutures = ref.watch(postsFeaturesProvider);
    final Widget Function(BuildContext) reportPostButtonBuilder = (innerContext) {
      return CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(onPressed: () async {
            Navigator.pop(innerContext);
            await postFutures.muteUser(context: context, audioPlayer: onePostModel.audioPlayer, afterUris: onePostModel.afterUris, muteUids: mainModel.muteUids, i: 0, results: onePostModel.onePostDocList, muteUsers: mainModel.muteUsers, post: onePostModel.onePostDoc.data()!, mainModel: mainModel);
          }, child: PositiveText(text: muteUserJaText) ),
          CupertinoActionSheetAction(onPressed: () async {
            Navigator.pop(innerContext);
            await postFutures.mutePost(context: context, mainModel: mainModel, i: 0, post: onePostModel.onePostDoc.data()!, afterUris: onePostModel.afterUris, audioPlayer: onePostModel.audioPlayer, results: onePostModel.onePostDocList);
          }, child: PositiveText(text: mutePostJaText) ),
          CupertinoActionSheetAction(onPressed: () async {
            Navigator.pop(innerContext);
            postFutures.reportPost(context: context, mainModel: mainModel, i: 0, post: Post.fromJson(onePostModel.onePostDoc.data()!), afterUris: onePostModel.afterUris, audioPlayer: onePostModel.audioPlayer, results: onePostModel.onePostDocList);
          }, child: PositiveText(text: reportPostJaText) ),
          CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText) ),
        ],
      );
    };
    return Scaffold(
      body: PostShowPage(
        speedNotifier: onePostModel.speedNotifier, 
        speedControll:  () async => await voids.setSpeed(audioPlayer: onePostModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: onePostModel.speedNotifier),
        currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, 
        progressNotifier: onePostModel.progressNotifier, 
        seek: onePostModel.seek, 
        repeatButtonNotifier: onePostModel.repeatButtonNotifier, 
        onRepeatButtonPressed:  () => voids.onRepeatButtonPressed(audioPlayer: onePostModel.audioPlayer, repeatButtonNotifier: onePostModel.repeatButtonNotifier),
        isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
        onPreviousSongButtonPressed:  () => voids.onPreviousSongButtonPressed(audioPlayer: onePostModel.audioPlayer),
        playButtonNotifier: onePostModel.playButtonNotifier, 
        play: () => voids.play(audioPlayer: onePostModel.audioPlayer),
        pause: () => voids.pause(audioPlayer: onePostModel.audioPlayer),
        isLastSongNotifier: onePostModel.isLastSongNotifier, 
        onNextSongButtonPressed:  () => voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer),
        toCommentsPage: () => routes.toCommentsPage(context: context, audioPlayer: onePostModel.audioPlayer, currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel  ),
        toEditingMode: () => voids.toEditPostInfoMode(audioPlayer: onePostModel.audioPlayer, editPostInfoModel: editPostInfoModel),
        postType: onePostModel.postType,
        mainModel: mainModel
      ),
    );
  }
}