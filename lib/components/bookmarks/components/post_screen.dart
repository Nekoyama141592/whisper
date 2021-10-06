// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/details/gradient_screen.dart';
// components
import 'package:whisper/posts/components/details/post_cards.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

class PostScreen extends StatelessWidget {
  
  const PostScreen({
    Key? key,
    required this.bookmarksModel,
    required this.currentUserDoc,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.likedCommentIds,
    required this.likedComments
  }) : super(key: key);

  final BookMarksModel bookmarksModel;
  final DocumentSnapshot currentUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;
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
      content: Padding(
        padding: const EdgeInsets.only(
          top: 20.0
        ),
        child: PostCards(
          likedPostIds: likedPostIds, 
          bookmarkedPostIds: bookmarkedPostIds, 
          postDocs: postDocs, 
          route: () {
            routes.toPostShowPage(
              context, 
              likedPostIds, 
              bookmarkedPostIds, 
              likedCommentIds,
              likedComments,
              currentUserDoc, 
              bookmarksModel.currentSongDocNotifier, 
              bookmarksModel.progressNotifier, 
              bookmarksModel.seek, 
              bookmarksModel.repeatButtonNotifier, 
              () { bookmarksModel.onRepeatButtonPressed(); }, 
              bookmarksModel.isFirstSongNotifier, 
              () { bookmarksModel.onPreviousSongButtonPressed(); }, 
              bookmarksModel.playButtonNotifier, 
              () { bookmarksModel.play(); }, 
              () { bookmarksModel.pause(); }, 
              bookmarksModel.isLastSongNotifier, 
              () { bookmarksModel.onNextSongButtonPressed(); }
            );
          }, 
          progressNotifier: bookmarksModel.progressNotifier, 
          seek: bookmarksModel.seek, 
          currentSongDocNotifier: bookmarksModel.currentSongDocNotifier ,
          playButtonNotifier: bookmarksModel.playButtonNotifier, 
          play: () { bookmarksModel.play(); }, 
          pause: () { bookmarksModel.pause(); }, 
          currentUserDoc: currentUserDoc,
          refreshController: bookmarksModel.refreshController,
          onRefresh: () { bookmarksModel.onRefresh(); },
          onLoading: () { bookmarksModel.onLoading(); },
        ),
      ), 
      circular: 35.0
    );
  }
}