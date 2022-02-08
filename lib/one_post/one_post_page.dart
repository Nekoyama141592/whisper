// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// comopnents
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// other_pages
import 'package:whisper/posts/components/other_pages/post_show/post_show_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

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
    final officialAdsensesModel = ref.watch(officialAdsensesProvider); 

    return Scaffold(
      body: PostShowPage(
        speedNotifier: onePostModel.speedNotifier, 
        speedControll:  () async { await voids.setSpeed(audioPlayer: onePostModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: onePostModel.speedNotifier); },
        currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, 
        progressNotifier: onePostModel.progressNotifier, 
        seek: onePostModel.seek, 
        repeatButtonNotifier: onePostModel.repeatButtonNotifier, 
        onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: onePostModel.audioPlayer, repeatButtonNotifier: onePostModel.repeatButtonNotifier); }, 
        isFirstSongNotifier: onePostModel.isFirstSongNotifier, 
        onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: onePostModel.audioPlayer); }, 
        playButtonNotifier: onePostModel.playButtonNotifier, 
        play: () async { 
          await voids.play(context: context, audioPlayer: onePostModel.audioPlayer, mainModel: mainModel, postId: onePostModel.currentWhisperPostNotifier.value!.postId, officialAdsensesModel: officialAdsensesModel);
        }, 
        pause: () { voids.pause(audioPlayer: onePostModel.audioPlayer); },
        isLastSongNotifier: onePostModel.isLastSongNotifier, 
        onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: onePostModel.audioPlayer); },
        toCommentsPage: () {
          routes.toCommentsPage(context: context, audioPlayer: onePostModel.audioPlayer, currentWhisperPostNotifier: onePostModel.currentWhisperPostNotifier, mainModel: mainModel,commentsOrReplysModel: commentsOrReplysModel  );
        },
        toEditingMode: () { voids.toEditPostInfoMode(audioPlayer: onePostModel.audioPlayer, editPostInfoModel: editPostInfoModel); },
        postType: onePostModel.postType,
        mainModel: mainModel
      ),
    );
  }
}