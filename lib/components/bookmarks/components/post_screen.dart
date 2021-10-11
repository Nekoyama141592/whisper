// material
import 'package:flutter/material.dart';
// packages
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/details/nothing.dart';
// components
import 'package:whisper/posts/components/details/post_cards.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

class PostScreen extends StatelessWidget {
  
  const PostScreen({
    Key? key,
    required this.bookmarksModel,
    required this.mainModel
  }) : super(key: key);

  final BookMarksModel bookmarksModel;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context) {
    final postDocs = bookmarksModel.bookmarkedDocs;
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
      Nothing()
      : Padding(
        padding: const EdgeInsets.only(
          top: 20.0
        ),
        child: PostCards(
          likedPostIds: mainModel.likedPostIds, 
          bookmarkedPostIds: mainModel.bookmarkedPostIds, 
          likes: mainModel.likes,
          postDocs: postDocs, 
          route: () {
            routes.toPostShowPage(
              context, 
              bookmarksModel.currentSongDocNotifier, 
              bookmarksModel.progressNotifier, 
              bookmarksModel.seek, 
              bookmarksModel.repeatButtonNotifier, 
              () { bookmarksModel.onRepeatButtonPressed(); }, 
              bookmarksModel.isFirstSongNotifier, 
              () { bookmarksModel.onPreviousSongButtonPressed(); }, 
              bookmarksModel.playButtonNotifier, 
              () { bookmarksModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
              () { bookmarksModel.pause(); }, 
              bookmarksModel.isLastSongNotifier, 
              () { bookmarksModel.onNextSongButtonPressed(); },
              mainModel
            );
          }, 
          progressNotifier: bookmarksModel.progressNotifier, 
          seek: bookmarksModel.seek, 
          currentSongDocNotifier: bookmarksModel.currentSongDocNotifier ,
          playButtonNotifier: bookmarksModel.playButtonNotifier, 
          play: () { bookmarksModel.play(mainModel.readPostIds, mainModel.readPosts, mainModel.currentUserDoc); }, 
          pause: () { bookmarksModel.pause(); }, 
          currentUserDoc: mainModel.currentUserDoc,
          refreshController: bookmarksModel.refreshController,
          onRefresh: () { bookmarksModel.onRefresh(); },
          onLoading: () { bookmarksModel.onLoading(); },
          mainModel: mainModel,
        ),
      ), 
      circular: 35.0
    );
  }
}