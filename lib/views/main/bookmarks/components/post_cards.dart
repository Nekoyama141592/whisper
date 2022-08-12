// material
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// notifiers
import 'package:whisper/posts/notifiers/progress_notifier.dart';
import 'package:whisper/posts/notifiers/play_button_notifier.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/bookmarks_model.dart';
import 'package:whisper/models/posts/posts_model.dart';

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
    required this.onLoading,
    required this.isFirstSongNotifier,
    required this.onPreviousSongButtonPressed,
    required this.isLastSongNotifier,
    required this.onNextSongButtonPressed,
    required this.mainModel,
    required this.bookmarksModel,
    required this.postFutures
  }) : super(key: key);

 
  final List<DocumentSnapshot<Map<String,dynamic>>> postDocs;
  final void Function()? route;
  final ProgressNotifier progressNotifier;
  final void Function(Duration)? seek;
  final ValueNotifier<Post?> currentWhisperPostNotifier;
  final PlayButtonNotifier playButtonNotifier;
  final void Function()? play;
  final void Function()? pause;
  // refresh
  final RefreshController refreshController;
  final void Function()? onLoading;
  final ValueNotifier<bool> isFirstSongNotifier;
  final void Function()? onPreviousSongButtonPressed;
  final ValueNotifier<bool> isLastSongNotifier;
  final void Function()? onNextSongButtonPressed;
  final MainModel mainModel;
  final BookmarksModel bookmarksModel;
  final PostsModel postFutures;

  @override 
  Widget build(BuildContext context) {
    final subWidget = ValueListenableBuilder<Post?>(
      valueListenable: bookmarksModel.currentWhisperPostNotifier,
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
    );
    return RefreshScreen(
      isEmpty: bookmarksModel.posts.isEmpty,
      subWidget: subWidget,
      controller: bookmarksModel.refreshController,
      // TODO: onRefresh: () async => await bookmarksModel.onRefresh(),
      onRefresh: () {},
      onReload: () async => await bookmarksModel.onReload(mainModel: mainModel),
      onLoading: () async => await bookmarksModel.onLoading(),
      child: ListView.builder(
        itemCount: postDocs.length,
        itemBuilder: (BuildContext context, int i) {
          final postDoc = postDocs[i];
          final Map<String,dynamic> post = postDoc.data() as Map<String,dynamic>;
          final Post whisperPost = Post.fromJson(post);
          return 
          PostCard(
            postDoc: postDoc,
            onDeleteButtonPressed: () { postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: bookmarksModel.audioPlayer, whisperPost: whisperPost, afterUris: bookmarksModel.afterUris, posts: bookmarksModel.posts, mainModel: mainModel, i: i); },
            initAudioPlayer: () async => await postFutures.initAudioPlayer(audioPlayer: bookmarksModel.audioPlayer, afterUris: bookmarksModel.afterUris, i: i),
            muteUser: () async => await postFutures.muteUser(context: context,audioPlayer: bookmarksModel.audioPlayer, afterUris: bookmarksModel.afterUris, muteUids: mainModel.muteUids, i: i, results: bookmarksModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel),
            mutePost: () async => await postFutures.mutePost(context: context,mainModel: mainModel, i: i, postDoc: postDoc, afterUris: bookmarksModel.afterUris, audioPlayer: bookmarksModel.audioPlayer, results: bookmarksModel.posts ),
            reportPost: () => postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: Post.fromJson(post), afterUris: bookmarksModel.afterUris, audioPlayer: bookmarksModel.audioPlayer, results: bookmarksModel.posts ),
            reportPostButtonBuilder:  (innerContext) {
              return CupertinoActionSheet(
                actions: whisperPost.uid == mainModel.userMeta.uid ?
                [  
                  CupertinoActionSheetAction(onPressed: () {
                    Navigator.pop(innerContext);
                    postFutures.onPostDeleteButtonPressed(context: context, audioPlayer: bookmarksModel.audioPlayer, whisperPost: whisperPost, afterUris: bookmarksModel.afterUris, posts: bookmarksModel.posts, mainModel: mainModel, i: i);
                  }, child: PositiveText(text: deletePostText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                ]
                : [
                  CupertinoActionSheetAction(onPressed: () async {
                    Navigator.pop(innerContext);
                    await postFutures.muteUser(context: context, audioPlayer: bookmarksModel.audioPlayer, afterUris: bookmarksModel.afterUris, muteUids: mainModel.muteUids, i: i, results: bookmarksModel.posts, muteUsers: mainModel.muteUsers, whisperPost: whisperPost, mainModel: mainModel);
                  }, child: PositiveText(text: muteUserText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () async {
                    Navigator.pop(innerContext);
                    await postFutures.mutePost(context: context, mainModel: mainModel, i: i, postDoc: postDoc, afterUris: bookmarksModel.afterUris, audioPlayer: bookmarksModel.audioPlayer, results: bookmarksModel.posts);
                  }, child: PositiveText(text: mutePostText(context: context)) ),
                  CupertinoActionSheetAction(onPressed: () {
                    Navigator.pop(innerContext);
                    postFutures.reportPost(context: context, mainModel: mainModel, i: i, post: whisperPost, afterUris: bookmarksModel.afterUris, audioPlayer: bookmarksModel.audioPlayer, results: bookmarksModel.posts);
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