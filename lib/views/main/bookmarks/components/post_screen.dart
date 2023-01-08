// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/views/main/bookmarks/components/post_cards.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/bookmarks_model.dart';
import 'package:whisper/models/comments/comments_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/models/edit_post_info/edit_post_info_model.dart';
import 'package:whisper/models/posts/posts_model.dart';

class PostScreen extends ConsumerWidget {
  
  const PostScreen({
    Key? key,
    required this.bookmarksModel,
    required this.mainModel
  }) : super(key: key);

  final BookmarksModel bookmarksModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final EditPostInfoModel editPostInfoModel = ref.watch(editPostInfoProvider); 
    final CommentsModel commentsModel = ref.watch(commentsProvider);
    final PostsModel postFutures = ref.watch(postsFeaturesProvider);
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);

    final postDocs = bookmarksModel.posts;
    
    return GradientScreen(
      top: SizedBox.shrink(), 
      header: Padding(
        padding: EdgeInsets.all(defaultPadding(context: context)),
        child: Row(
          children: [
            InkWell(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                bookmarksModel.back();
              },
            ),
           whiteBoldEllipsisHeaderText(context: context,text: 'BookMarks')
          ],
        ),
      ),
      child: postDocs.isEmpty ?
      Nothing(reload: () async => await bookmarksModel.onReload(mainModel: mainModel, ))
      : Padding(
        padding: EdgeInsets.only(
          top: defaultPadding(context: context),
        ),
        child: PostCards(
          postDocs: postDocs, 
          postFutures: postFutures,
          route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: bookmarksModel.speedNotifier,
            speedControll:  () async => await bookmarksModel.speedControll(),
            currentWhisperPostNotifier: bookmarksModel.currentWhisperPostNotifier, 
            progressNotifier: bookmarksModel.progressNotifier, 
            seek: bookmarksModel.seek, 
            repeatButtonNotifier: bookmarksModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () => bookmarksModel.onRepeatButtonPressed(),
            isFirstSongNotifier: bookmarksModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () => bookmarksModel.onPreviousSongButtonPressed(),
            playButtonNotifier: bookmarksModel.playButtonNotifier, 
            play: () => bookmarksModel.play(),
            pause: () => bookmarksModel.pause(),
            isLastSongNotifier: bookmarksModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () => bookmarksModel.onNextSongButtonPressed(),
            toCommentsPage:  () async => await commentsModel.init(context: context, audioPlayer: bookmarksModel.audioPlayer, whisperPostNotifier: bookmarksModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: bookmarksModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel ),
            toEditingMode:  () => bookmarksModel.toEditPostInfoMode(editPostInfoModel: editPostInfoModel),
            postType: bookmarksModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: bookmarksModel.progressNotifier,
        seek: bookmarksModel.seek,
        currentWhisperPostNotifier: bookmarksModel.currentWhisperPostNotifier,
        playButtonNotifier: bookmarksModel.playButtonNotifier,
        play: () => bookmarksModel.play(),
        pause: () => bookmarksModel.pause(),
        refreshController: bookmarksModel.refreshController,
        onLoading: () async => await bookmarksModel.onLoading(),
        isFirstSongNotifier: bookmarksModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () => bookmarksModel.onPreviousSongButtonPressed(),
        isLastSongNotifier: bookmarksModel.isLastSongNotifier,
        onNextSongButtonPressed: () => bookmarksModel.onNextSongButtonPressed(),
          mainModel: mainModel,
          bookmarksModel: bookmarksModel,
        ),
      ), 
      circular: defaultPadding(context: context)
    );
  }
}