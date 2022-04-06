// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/components/user_show/components/details/post_cards.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/comments/comments_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';
class UserShowPostScreen extends ConsumerWidget {
  
  const UserShowPostScreen({
    Key? key,
    required this.userShowModel,
    required this.mainModel
  }) : super(key: key);

  final UserShowModel userShowModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final PostFutures postFutures = ref.watch(postsFeaturesProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);

    final postDocs = userShowModel.posts;
    final Widget posts = Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        controller: userShowModel.refreshController,
        onRefresh: () async {
          await userShowModel.onRefresh();
        },
        onLoading: () async {
          await userShowModel.onLoading();
        },
        child: ListView.builder(
          itemCount: postDocs.length,
          itemBuilder: (BuildContext context, int i) {
            final Map<String,dynamic> post = postDocs[i].data() as Map<String,dynamic>;
            return 
            PostCard(
              post: post,
              onDeleteButtonPressed: () { postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: userShowModel.audioPlayer, postMap: postDocs[i].data() as Map<String,dynamic>, afterUris: userShowModel.afterUris, posts: userShowModel.posts, mainModel: mainModel, i: i); },
              initAudioPlayer: () async => await postFutures.initAudioPlayer(audioPlayer: userShowModel.audioPlayer, afterUris: userShowModel.afterUris, i: i),
              muteUser: () async => await postFutures.muteUser(context: context,audioPlayer: userShowModel.audioPlayer, afterUris: userShowModel.afterUris, mutesUids: mainModel.muteUids, i: i, results: userShowModel.posts, muteUsers: mainModel.muteUsers, post: post, mainModel: mainModel),
              mutePost: () async => await postFutures.mutePost(context: context,mainModel: mainModel, i: i, post: post, afterUris: userShowModel.afterUris, audioPlayer: userShowModel.audioPlayer, results: userShowModel.posts ),
              reportPost: () => postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: userShowModel.afterUris, audioPlayer: userShowModel.audioPlayer, results: userShowModel.posts ),
              mainModel: mainModel,
            );
          }
        ),
      ),
    );
    final content =  Padding(
      padding: EdgeInsets.only(top: defaultPadding(context: context) ),
      child: PostCards(
        postDocs: userShowModel.posts, 
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: userShowModel.speedNotifier,
            speedControll:  () async => await voids.speedControll(audioPlayer: userShowModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: userShowModel.speedNotifier),
            currentWhisperPostNotifier: userShowModel.currentWhisperPostNotifier, 
            progressNotifier: userShowModel.progressNotifier, 
            seek: userShowModel.seek, 
            repeatButtonNotifier: userShowModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () => voids.onRepeatButtonPressed(audioPlayer: userShowModel.audioPlayer, repeatButtonNotifier: userShowModel.repeatButtonNotifier),
            isFirstSongNotifier: userShowModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () => voids.onPreviousSongButtonPressed(audioPlayer: userShowModel.audioPlayer),
            playButtonNotifier: userShowModel.playButtonNotifier, 
            play: () => voids.play(audioPlayer: userShowModel.audioPlayer),
            pause: () => voids.pause(audioPlayer: userShowModel.audioPlayer),
            isLastSongNotifier: userShowModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () => voids.onNextSongButtonPressed(audioPlayer: userShowModel.audioPlayer),
            toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: userShowModel.audioPlayer, whisperPostNotifier: userShowModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: userShowModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
            toEditingMode:  () => voids.toEditPostInfoMode(audioPlayer: userShowModel.audioPlayer, editPostInfoModel: editPostInfoModel),
            postType: userShowModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: userShowModel.progressNotifier,
        seek: userShowModel.seek,
        currentWhisperPostNotifier: userShowModel.currentWhisperPostNotifier,
        playButtonNotifier: userShowModel.playButtonNotifier,
        play: () => voids.play(audioPlayer: userShowModel.audioPlayer),
        pause: () => voids.pause(audioPlayer: userShowModel.audioPlayer),
        refreshController: userShowModel.refreshController,
        onRefresh: () async => await userShowModel.onRefresh(),
        onLoading: () async => await userShowModel.onLoading(),
        isFirstSongNotifier: userShowModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () => voids.onPreviousSongButtonPressed(audioPlayer: userShowModel.audioPlayer),
        isLastSongNotifier: userShowModel.isLastSongNotifier,
        onNextSongButtonPressed: () => voids.onNextSongButtonPressed(audioPlayer: userShowModel.audioPlayer),
        mainModel: mainModel,
        posts: posts,
      ),
    );
    
    return 
    JudgeScreen(
      list: postDocs, 
      content: content,
      reload: () async => await userShowModel.onReload()
    );
    
  }
}