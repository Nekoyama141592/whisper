// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/bookmarks/components/post_cards.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/official_advertisements/official_advertisement_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

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
    final officialAdsensesModel = ref.watch(officialAdvertisementsProvider); 
    final PostFutures postFutures = ref.watch(postsFeaturesProvider);
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
            Text(
              'BookMarks',
              style: TextStyle(
                color: Colors.white,
                fontSize: defaultHeaderTextSize(context: context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      content: postDocs.isEmpty ?
      Nothing(reload: () async { 
        await bookmarksModel.onReload(mainModel: mainModel, );
      })
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
            speedControll:  () async { await voids.speedControll(audioPlayer: bookmarksModel.audioPlayer, prefs: mainModel.prefs,speedNotifier: bookmarksModel.speedNotifier); },
            currentWhisperPostNotifier: bookmarksModel.currentWhisperPostNotifier, 
            progressNotifier: bookmarksModel.progressNotifier, 
            seek: bookmarksModel.seek, 
            repeatButtonNotifier: bookmarksModel.repeatButtonNotifier, 
            onRepeatButtonPressed:  () { voids.onRepeatButtonPressed(audioPlayer: bookmarksModel.audioPlayer, repeatButtonNotifier: bookmarksModel.repeatButtonNotifier); }, 
            isFirstSongNotifier: bookmarksModel.isFirstSongNotifier, 
            onPreviousSongButtonPressed:  () { voids.onPreviousSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); }, 
            playButtonNotifier: bookmarksModel.playButtonNotifier, 
            play: () { voids.play(audioPlayer: bookmarksModel.audioPlayer,officialAdvertisement: officialAdsensesModel); }, 
            pause: () { voids.pause(audioPlayer: bookmarksModel.audioPlayer); }, 
            isLastSongNotifier: bookmarksModel.isLastSongNotifier, 
            onNextSongButtonPressed:  () { voids.onNextSongButtonPressed(audioPlayer: bookmarksModel.audioPlayer); },
            toCommentsPage:  () async {
              await commentsModel.init(context: context, audioPlayer: bookmarksModel.audioPlayer, whisperPostNotifier: bookmarksModel.currentWhisperPostNotifier, mainModel: mainModel, whisperPost: bookmarksModel.currentWhisperPostNotifier.value!,commentsOrReplysModel: commentsOrReplysModel );
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
        currentWhisperPostNotifier: bookmarksModel.currentWhisperPostNotifier,
        playButtonNotifier: bookmarksModel.playButtonNotifier,
        play: () { voids.play(audioPlayer: bookmarksModel.audioPlayer,officialAdvertisement: officialAdsensesModel); }, 
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
      circular: defaultPadding(context: context)
    );
  }
}