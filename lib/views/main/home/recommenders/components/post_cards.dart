// material
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/recommenders_model.dart';

class PostCards extends StatelessWidget {

  const PostCards({
    Key? key,
    required this.postDocs,
    required this.route,
    required this.progressNotifier,
    required this.seek,
    required this.currentWhisperPostNotifier,
    required this.playButtonNotifier,
    required this.play,
    required this.pause,
    required this.refreshController,
    required this.onRefresh,
    required this.onReload,
    required this.onLoading,
     required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed,
    required this.mainModel,
    required this.recommendersModel,
  }) : super(key: key);

 
  final List<QueryDocumentSnapshot<Map<String,dynamic>>> postDocs;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<Post?> currentWhisperPostNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  // refresh
  final RefreshController refreshController;
  final void Function()? onRefresh;
  final void Function()? onReload;
  final void Function()? onLoading;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  final MainModel mainModel;
  final RecommendersModel recommendersModel;

  @override 
  Widget build(BuildContext context) {
    return RefreshScreen(
      onRefresh: onRefresh,
      onReload: onReload,
      onLoading: onLoading, 
      isEmpty: postDocs.isEmpty,
      controller: refreshController, 
      subWidget: ValueListenableBuilder<Post?>(
        valueListenable: recommendersModel.currentWhisperPostNotifier,
        builder: (_,whisperPost,__) {
          return AudioWindow(
            route: route, 
            progressNotifier: progressNotifier, 
            seek: seek, 
            whisperPost: whisperPost!,
            playButtonNotifier: playButtonNotifier, 
            play: play, 
            pause: pause, 
            isFirstSongNotifier: isFirstSongNotifier,
            onPreviousSongButtonPressed: onPreviousSongButtonPressed,
            isLastSongNotifier: isLastSongNotifier,
            onNextSongButtonPressed: onNextSongButtonPressed,
            mainModel: mainModel,
          );
        }
      ),
      child: ListView.builder(
        itemCount: postDocs.length,
        itemBuilder: (BuildContext context, int i) {
          final postDoc = postDocs[i];
          final Map<String,dynamic> post = postDoc.data();
          final Post whisperPost = Post.fromJson(post);
          return 
          PostCard(
            postDoc: postDoc,
            onDeleteButtonPressed: () => recommendersModel.onPostDeleteButtonPressed(context: context, audioPlayer: recommendersModel.audioPlayer, whisperPost:whisperPost, afterUris: recommendersModel.afterUris, posts: recommendersModel.posts, mainModel: mainModel, i: i),
            initAudioPlayer: () async => await recommendersModel.initAudioPlayer(audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, i: i),
            muteUser: () async => await recommendersModel.muteUser(context: context,audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, muteUids: mainModel.muteUids, i: i, results: recommendersModel.posts, muteUsers: mainModel.muteUsers, whisperPost:whisperPost, mainModel: mainModel),
            mutePost: () async => await recommendersModel.mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: recommendersModel.afterUris, audioPlayer: recommendersModel.audioPlayer, results: recommendersModel.posts ),
            reportPost: () => recommendersModel.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: recommendersModel.afterUris, audioPlayer: recommendersModel.audioPlayer, results: recommendersModel.posts ),
            reportPostButtonBuilder:  (innerContext) {
              return CupertinoActionSheet(
                actions: whisperPost.uid == mainModel.userMeta.uid ?
                [  
                  CupertinoActionSheetAction(onPressed: () {
                    Navigator.pop(innerContext);
                    recommendersModel.onPostDeleteButtonPressed(context: context, audioPlayer: recommendersModel.audioPlayer,whisperPost:whisperPost, afterUris: recommendersModel.afterUris, posts: recommendersModel.posts, mainModel: mainModel, i: i);
                  }, child: PositiveText(text: deletePostText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                ]
                : [
                  CupertinoActionSheetAction(onPressed: () async {
                    Navigator.pop(innerContext);
                    await recommendersModel.muteUser(context: context, audioPlayer: recommendersModel.audioPlayer, afterUris: recommendersModel.afterUris, muteUids: mainModel.muteUids, i: i, results: recommendersModel.posts, muteUsers: mainModel.muteUsers, whisperPost:whisperPost, mainModel: mainModel);
                  }, child: PositiveText(text: muteUserText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () async {
                    Navigator.pop(innerContext);
                    await recommendersModel.mutePost(context: context, mainModel: mainModel, i: i, postDoc: postDoc,afterUris: recommendersModel.afterUris, audioPlayer: recommendersModel.audioPlayer, results: recommendersModel.posts);
                  }, child: PositiveText(text: mutePostText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () {
                    Navigator.pop(innerContext);
                    recommendersModel.reportPost(context: context, mainModel: mainModel, i: i, post: whisperPost, afterUris: recommendersModel.afterUris, audioPlayer: recommendersModel.audioPlayer, results: recommendersModel.posts);
                  }, child: PositiveText(text: reportPostText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                ],
              );
            },
            mainModel: mainModel,
          );
        }
      ),
    );
  }
}