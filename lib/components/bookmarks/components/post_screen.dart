// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/bookmarks/components/post_cards.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_adsenses/official_adsenses_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

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

    final editPostInfoModel = ref.watch(editPostInfoProvider); 
    final commentsModel = ref.watch(commentsProvider);
    final officialAdsensesModel = ref.watch(officialAdsensesProvider); 
    final postDocs = bookmarksModel.posts;
    final Post post = fromMapToPost(postMap: bookmarksModel.currentSongMapNotifier.value);
    
    return GradientScreen(
      top: SizedBox.shrink(), 
      header: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          'BookMarks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: postDocs.isEmpty ?
      Nothing(reload: () async { 
        await bookmarksModel.onReload();
      })
      : Padding(
        padding: const EdgeInsets.only(
          top: 20.0
        ),
        child: PostCards(
          postDocs: postDocs, 
          route: () {
          routes.toPostShowPage(
            context: context,
            speedNotifier: bookmarksModel.speedNotifier,
            speedControll:  () async { await voids.speedControll(audioPlayer: bookmarksModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: bookmarksModel.speedNotifier); },
            currentSongMapNotifier: bookmarksModel.currentSongMapNotifier, 
            progressNotifier: bookmarksModel.progressNotifier, 
            seek: bookmarksModel.seek, 
            repeatButtonNotifier: bookmarksModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: bookmarksModel.audioPlayer, repeatButtonNotifier: bookmarksModel.repeatButtonNotifier); }, 
            isFirstSongNotifier: bookmarksModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); }, 
            playButtonNotifier: bookmarksModel.playButtonNotifier, 
            play: () async { 
              await voids.play(context: context, audioPlayer: bookmarksModel.audioPlayer, mainModel: mainModel, postId: post.postId, officialAdsensesModel: officialAdsensesModel);
            }, 
            pause: () { voids.pause(audioPlayer: bookmarksModel.audioPlayer); }, 
            isLastSongNotifier: bookmarksModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); },
            toCommentsPage:  () async {
              await commentsModel.init(context: context, audioPlayer: bookmarksModel.audioPlayer, whisperPostNotifier: bookmarksModel.currentSongMapNotifier, mainModel: mainModel, whisperPost: post );
            },
            toEditingMode:  () {
              voids.toEditPostInfoMode(audioPlayer: bookmarksModel.audioPlayer, editPostInfoModel: editPostInfoModel);
            },
            postType: bookmarksModel.postType,
            mainModel: mainModel
          ); 
        }, 
        progressNotifier: bookmarksModel.progressNotifier,
        seek: bookmarksModel.seek,
        currentSongMapNotifier: bookmarksModel.currentSongMapNotifier,
        playButtonNotifier: bookmarksModel.playButtonNotifier,
        play: () async {
          await voids.play(context: context, audioPlayer: bookmarksModel.audioPlayer, mainModel: mainModel, postId: post.postId, officialAdsensesModel: officialAdsensesModel);
        },
        pause: () {
          voids.pause(audioPlayer: bookmarksModel.audioPlayer);
        }, 
        refreshController: bookmarksModel.refreshController,
        onLoading: () async { await bookmarksModel.onLoading(); },
        isFirstSongNotifier: bookmarksModel.isFirstSongNotifier,
        onPreviousSongButtonPressed: () { voids.onPreviousSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); },
        isLastSongNotifier: bookmarksModel.isLastSongNotifier,
        onNextSongButtonPressed: () { voids.onNextSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); },
          mainModel: mainModel,
          bookmarksModel: bookmarksModel,
        ),
      ), 
      circular: 35.0
    );
  }
}