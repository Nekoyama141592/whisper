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
  }) : super(key: key);

  final BookMarksModel bookmarksModel;
  final DocumentSnapshot currentUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    final postDocs = bookmarksModel.bookmarkedDocs;
    return GradientScreen(
      top: SizedBox.shrink(), 
      header: Text(
        'BookMarks',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: PostCards(
        likedPostIds: likedPostIds, 
        bookmarkedPostIds: bookmarkedPostIds, 
        postDocs: postDocs, 
        route: () {
          routes.toPostShowPage(
            context, 
            likedPostIds, 
            bookmarkedPostIds, 
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
        currentUserDoc: currentUserDoc
      ), 
      circular: 35.0
    );
  }
}