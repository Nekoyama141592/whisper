// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/loading.dart';
// model
import 'package:whisper/components/bookmarks/bookmarks_model.dart';


class BookmarkCard extends StatelessWidget {
  
  BookmarkCard({
    required this.bookmarksModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  });

  final BookMarksModel bookmarksModel;
  final List preservatedPostIds;
  final List likedPostIds;

  @override 
  Widget build(BuildContext context) {
    return Container(
      child: 
      bookmarksModel.isLoading ?
      Loading()
      : bookmarksModel.preservationDocs.isEmpty ?
      Nothing()
      : 
      Padding(
        padding: const EdgeInsets.only(top:20,),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bookmarksModel.preservationDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                  PostCard(postDoc: bookmarksModel.preservationDocs[i])
              ),
            ),
            AudioWindow(
              preservatedPostIds: preservatedPostIds, 
              likedPostIds: likedPostIds, 
              route: (){
                routes.toBookmarksShowPage(
                  context, 
                  bookmarksModel.currentUserDoc, 
                  bookmarksModel, 
                  preservatedPostIds, 
                  likedPostIds
                );
              },
              progressNotifier: bookmarksModel.progressNotifier, 
              seek: bookmarksModel.seek, 
              currentSongDocNotifier: bookmarksModel.currentSongDocNotifier, 
              playButtonNotifier: bookmarksModel.playButtonNotifier,
              play: () {
                bookmarksModel.play();
              }, 
              pause: () {
                bookmarksModel.pause();
              }, 
              currentUserDoc: bookmarksModel.currentUserDoc
            )
          ],
        ),
      ),
    );
  }
}