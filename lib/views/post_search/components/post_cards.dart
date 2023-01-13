// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/models/post_search/post_search_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';

class PostCards extends ConsumerWidget {

  const PostCards({
    Key? key,
    required this.passiveWhisperUser,
    required this.results,
    required this.mainModel,
    required this.postSearchModel,
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;
  final List<QueryDocumentSnapshot<Map<String,dynamic>>> results;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    
    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider);
    final CommentsModel commentsModel = ref.watch(commentsProvider);
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
                final postDoc = results[i];
                final Map<String,dynamic> post = postDoc.data();
                final Post whisperPost = Post.fromJson(post);
                return 
                PostCard(
                  postDoc: postDoc,
                  onDeleteButtonPressed: () => postSearchModel.onPostDeleteButtonPressed(context: context, audioPlayer: postSearchModel.audioPlayer, whisperPost: whisperPost, afterUris: postSearchModel.afterUris, posts: postSearchModel.posts, mainModel: mainModel, i: i),
                  initAudioPlayer: () async => await postSearchModel.initAudioPlayer(audioPlayer: postSearchModel.audioPlayer, afterUris: postSearchModel.afterUris, i: i),
                  muteUser: () async => await postSearchModel.muteUser(context: context,audioPlayer: postSearchModel.audioPlayer, afterUris: postSearchModel.afterUris, muteUids: mainModel.muteUids, i: i, results: postSearchModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel),
                  mutePost: () async => await postSearchModel.mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.posts ),
                  reportPost: () => postSearchModel.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.posts ),
                  reportPostButtonBuilder:  (innerContext) {
                    return CupertinoActionSheet(
                      actions: whisperPost.uid == mainModel.userMeta.uid ?
                        [  
                          CupertinoActionSheetAction(onPressed: () {
                            Navigator.pop(innerContext);
                            postSearchModel.onPostDeleteButtonPressed(context: context, audioPlayer: postSearchModel.audioPlayer, whisperPost: whisperPost, afterUris: postSearchModel.afterUris, posts: postSearchModel.posts, mainModel: mainModel, i: i);
                          }, child: PositiveText(text: deletePostText(context: context)) ),
                          CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                        ]
                        : [
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await postSearchModel.muteUser(context: context, audioPlayer: postSearchModel.audioPlayer, afterUris: postSearchModel.afterUris, muteUids: mainModel.muteUids, i: i, results: postSearchModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel);
                        }, child: PositiveText(text: muteUserText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await postSearchModel.mutePost(context: context, mainModel: mainModel, i: i, postDoc: postDoc, afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.posts);
                        }, child: PositiveText(text: mutePostText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () {
                          Navigator.pop(innerContext);
                          postSearchModel.reportPost(context: context, mainModel: mainModel, i: i, post: whisperPost, afterUris: postSearchModel.afterUris, audioPlayer: postSearchModel.audioPlayer, results: postSearchModel.posts);
                        }, child: PositiveText(text: reportPostText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                      ],
                    );
                  },
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
                    speedControll:  () async => await postSearchModel.speedControll(),
                    currentWhisperPostNotifier: postSearchModel.currentWhisperPostNotifier, 
                    progressNotifier: postSearchModel.progressNotifier, 
                    seek: postSearchModel.seek, 
                    repeatButtonNotifier: postSearchModel.repeatButtonNotifier, 
                    onRepeatButtonPressed:  () => postSearchModel.onRepeatButtonPressed(),
                    isFirstSongNotifier: postSearchModel.isFirstSongNotifier, 
                    onPreviousSongButtonPressed:  () => postSearchModel.onPreviousSongButtonPressed(),
                    playButtonNotifier: postSearchModel.playButtonNotifier, 
                    play: () => postSearchModel.play(),
                    pause: () => postSearchModel.pause(),
                    isLastSongNotifier: postSearchModel.isLastSongNotifier, 
                    onNextSongButtonPressed:  () => postSearchModel.onNextSongButtonPressed(),
                    toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: postSearchModel.audioPlayer, whisperPostNotifier: postSearchModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: postSearchModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
                    toEditingMode:  () => postSearchModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel),
                    mainModel: mainModel
                  ); 
                }, 
                progressNotifier: postSearchModel.progressNotifier,
                seek: postSearchModel.seek,
                whisperPost: whisperPost!,
                playButtonNotifier: postSearchModel.playButtonNotifier,
                play: () => postSearchModel.play(),
                pause: () => postSearchModel.pause(),
                isFirstSongNotifier: postSearchModel.isFirstSongNotifier,
                onPreviousSongButtonPressed: () => postSearchModel.onPreviousSongButtonPressed(),
                isLastSongNotifier: postSearchModel.isLastSongNotifier,
                onNextSongButtonPressed: () => postSearchModel.onNextSongButtonPressed(),
                mainModel: mainModel,
              );
            }
          )
        ],
      ),
    ) : SizedBox.shrink();
  }
}