// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/views/main/user_show/components/post_cards.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/models/main/my_profile_model.dart';
import 'package:whisper/models/posts/posts_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class MyProfilePostScreen extends ConsumerWidget {
  
  MyProfilePostScreen({
    Key? key,
    required this.myProfileModel,
    required this.mainModel
  });

  final MyProfileModel myProfileModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // modelのisLoadingはいらないかも
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final PostsModel postFutures = ref.watch(postsFeaturesProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);

    final postDocs = myProfileModel.posts;

    return Padding(
      padding: EdgeInsets.only(top: defaultPadding(context: context) ),
      child: PostCards(
        route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: myProfileModel.speedNotifier,
            speedControll:  () async => await voids.speedControll(audioPlayer: myProfileModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: myProfileModel.speedNotifier),
            currentWhisperPostNotifier: myProfileModel.currentWhisperPostNotifier, 
            progressNotifier: myProfileModel.progressNotifier, 
            seek: myProfileModel.seek, 
            repeatButtonNotifier: myProfileModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () => voids.onRepeatButtonPressed(audioPlayer: myProfileModel.audioPlayer, repeatButtonNotifier: myProfileModel.repeatButtonNotifier),
            isFirstSongNotifier: myProfileModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () => voids.onPreviousSongButtonPressed(audioPlayer: myProfileModel.audioPlayer),
            playButtonNotifier: myProfileModel.playButtonNotifier, 
            play: () => voids.play(audioPlayer: myProfileModel.audioPlayer),
            pause: () => voids.pause(audioPlayer: myProfileModel.audioPlayer),
            isLastSongNotifier: myProfileModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () => voids.onNextSongButtonPressed(audioPlayer: myProfileModel.audioPlayer),
            toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: myProfileModel.audioPlayer, whisperPostNotifier: myProfileModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: myProfileModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
            toEditingMode:  () => voids.toEditPostInfoMode(audioPlayer: myProfileModel.audioPlayer, editPostInfoModel: editPostInfoModel),
            postType: myProfileModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: myProfileModel.progressNotifier,
        seek: myProfileModel.seek,
        currentWhisperPostNotifier: myProfileModel.currentWhisperPostNotifier,
        playButtonNotifier: myProfileModel.playButtonNotifier,
        play: () => voids.play(audioPlayer: myProfileModel.audioPlayer),
        pause: () => voids.pause(audioPlayer: myProfileModel.audioPlayer),
        isFirstSongNotifier: myProfileModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () => voids.onPreviousSongButtonPressed(audioPlayer: myProfileModel.audioPlayer),
        isLastSongNotifier: myProfileModel.isLastSongNotifier,
        onNextSongButtonPressed: () => voids.onNextSongButtonPressed(audioPlayer: myProfileModel.audioPlayer),
        mainModel: mainModel,
        posts: RefreshScreen(
          isEmpty: myProfileModel.posts.isEmpty,
          subWidget: SizedBox.shrink(),
          controller: myProfileModel.refreshController,
          onRefresh: () async => await myProfileModel.onRefresh(),
          onReload: () async => await myProfileModel.onReload(),
          onLoading: () async => await myProfileModel.onLoading(),
          child: ListView.builder(
            itemCount: postDocs.length,
            itemBuilder: (BuildContext context, int i) {
              final postDoc = postDocs[i];
              final Map<String,dynamic> post = postDoc.data() as Map<String,dynamic>;
              final Post whisperPost = Post.fromJson(post);
              return 
              PostCard(
                postDoc: postDoc,
                onDeleteButtonPressed: () => postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: myProfileModel.audioPlayer, whisperPost: whisperPost, afterUris: myProfileModel.afterUris, posts: myProfileModel.posts, mainModel: mainModel, i: i),
                initAudioPlayer: () async => await postFutures.initAudioPlayer(audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, i: i),
                muteUser: () async => await postFutures.muteUser(context: context,audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, muteUids: mainModel.muteUids, i: i, results: myProfileModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel),
                mutePost: () async => await postFutures.mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: myProfileModel.afterUris, audioPlayer: myProfileModel.audioPlayer, results: myProfileModel.posts ),
                reportPost: () => postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: myProfileModel.afterUris, audioPlayer: myProfileModel.audioPlayer, results: myProfileModel.posts ),
                reportPostButtonBuilder:  (innerContext) {
                  return CupertinoActionSheet(
                    actions: whisperPost.uid == mainModel.userMeta.uid ?
                    [  
                      CupertinoActionSheetAction(onPressed: () {
                        Navigator.pop(innerContext);
                        postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: myProfileModel.audioPlayer, whisperPost: whisperPost, afterUris: myProfileModel.afterUris, posts: myProfileModel.posts, mainModel: mainModel, i: i);
                      }, child: PositiveText(text: deletePostText(context: context)) ),
                      CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                    ]
                    : [
                      CupertinoActionSheetAction(onPressed: () async {
                        Navigator.pop(innerContext);
                        await postFutures.muteUser(context: context, audioPlayer: myProfileModel.audioPlayer, afterUris: myProfileModel.afterUris, muteUids: mainModel.muteUids, i: i, results: myProfileModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel);
                      }, child: PositiveText(text: muteUserText(context: context)) ),
                      CupertinoActionSheetAction(onPressed: () async {
                        Navigator.pop(innerContext);
                        await postFutures.mutePost(context: context, mainModel: mainModel, i: i,postDoc: postDoc ,afterUris: myProfileModel.afterUris, audioPlayer: myProfileModel.audioPlayer, results: myProfileModel.posts);
                      }, child: PositiveText(text: mutePostText(context: context)) ),
                      CupertinoActionSheetAction(onPressed: () {
                        Navigator.pop(innerContext);
                        postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: whisperPost, afterUris: myProfileModel.afterUris, audioPlayer: myProfileModel.audioPlayer, results: myProfileModel.posts);
                      }, child: PositiveText(text: reportPostText(context: context)) ),
                      CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                    ],
                  );
                },
                mainModel: mainModel,
              );
            }
          ),
        )
      ),
    );
  }
}