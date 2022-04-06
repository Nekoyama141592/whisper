// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/comments/comments_model.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class PostCards extends ConsumerWidget {

  const PostCards({
    Key? key,
    required this.passiveWhisperUser,
    required this.results,
    required this.mainModel,
    required this.postSearchModel,
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;
  final List<DocumentSnapshot<Map<String,dynamic>>> results;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final PostFutures postFutures = ref.watch(postsFeaturesProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);

    return
    results.isNotEmpty ?
    Flexible(
      flex: 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int i) {
                final Map<String,dynamic> post = results[i].data()!;
                return 
                PostCard(
                  post: post,
                  onDeleteButtonPressed: () { postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: postSearchModel.audioPlayer, postMap: results[i].data()!, afterUris: postSearchModel.afterUris, posts: postSearchModel.results, mainModel: mainModel, i: i); },
                  initAudioPlayer: () async => await postFutures.initAudioPlayer(audioPlayer: postSearchModel.audioPlayer, afterUris: postSearchModel.afterUris, i: i),
                  muteUser: () async => await postFutures.muteUser(context: context,audioPlayer: postSearchModel.audioPlayer, afterUris: postSearchModel.afterUris, mutesUids: mainModel.muteUids, i: i, results: postSearchModel.results, muteUsers: mainModel.muteUsers, post: post, mainModel: mainModel),
                  mutePost: () async => await postFutures.mutePost(context: context,mainModel: mainModel, i: i, post: post, afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.results ),
                  reportPost: () => postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.results ),
                  mainModel: mainModel,
                );
              }
            )
          ),
          ValueListenableBuilder<Post?>(
            valueListenable: postSearchModel.currentWhisperPostNotifier,
            builder: (_,whisperPost,__) {
              return AudioWindow(
                route: () {
                  routes.toPostShowPage(
                    postType: postSearchModel.postType,
                    context: context,
                    speedNotifier: postSearchModel.speedNotifier,
                    speedControll:  () async => await voids.speedControll(audioPlayer: postSearchModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: postSearchModel.speedNotifier),
                    currentWhisperPostNotifier: postSearchModel.currentWhisperPostNotifier, 
                    progressNotifier: postSearchModel.progressNotifier, 
                    seek: postSearchModel.seek, 
                    repeatButtonNotifier: postSearchModel.repeatButtonNotifier, 
                    onRepeatButtonPressed:  () => voids.onRepeatButtonPressed(audioPlayer: postSearchModel.audioPlayer, repeatButtonNotifier: postSearchModel.repeatButtonNotifier),
                    isFirstSongNotifier: postSearchModel.isFirstSongNotifier, 
                    onPreviousSongButtonPressed:  () => voids.onPreviousSongButtonPressed(audioPlayer: postSearchModel.audioPlayer),
                    playButtonNotifier: postSearchModel.playButtonNotifier, 
                    play: () => voids.play(audioPlayer: postSearchModel.audioPlayer),
                    pause: () => voids.pause(audioPlayer: postSearchModel.audioPlayer),
                    isLastSongNotifier: postSearchModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () => voids.onNextSongButtonPressed(audioPlayer: postSearchModel.audioPlayer),
                    toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: postSearchModel.audioPlayer, whisperPostNotifier: postSearchModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: postSearchModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
                    toEditingMode:  () => voids.toEditPostInfoMode(audioPlayer: postSearchModel.audioPlayer, editPostInfoModel: editPostInfoModel),
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: postSearchModel.progressNotifier,
                seek: postSearchModel.seek,
                whisperPost: whisperPost!,
                playButtonNotifier: postSearchModel.playButtonNotifier,
                play: () => voids.play(audioPlayer: postSearchModel.audioPlayer),
                pause: () => voids.pause(audioPlayer: postSearchModel.audioPlayer),
                isFirstSongNotifier: postSearchModel.isFirstSongNotifier,
                onPreviousSongButtonPressed: () => voids.onPreviousSongButtonPressed(audioPlayer: postSearchModel.audioPlayer),
                isLastSongNotifier: postSearchModel.isLastSongNotifier,
                onNextSongButtonPressed: () => voids.onNextSongButtonPressed(audioPlayer: postSearchModel.audioPlayer),
                mainModel: mainModel,
              );
            }
          )
        ],
      ),
    ) : SizedBox.shrink();
  }
}