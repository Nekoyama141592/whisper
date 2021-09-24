import 'package:flutter/material.dart';

import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_state_items/audio_window.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

import 'package:whisper/constants/routes.dart' as routes;

class BookmarkCard extends StatelessWidget {
  
  BookmarkCard(
    this.bookmarksProvider,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final BookMarksModel bookmarksProvider;
  final List preservatedPostIds;
  final List likedPostIds;

  @override 
  Widget build(BuildContext context) {
    return Container(
      child: 
      bookmarksProvider.isLoading ?
      Loading()
      : bookmarksProvider.preservationDocs.isEmpty ?
      Nothing()
      : 
      Padding(
        padding: const EdgeInsets.only(top:20,),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bookmarksProvider.preservationDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                  PostCard(bookmarksProvider.preservationDocs[i])
              ),
            ),
            AudioWindow(
              preservatedPostIds,
              likedPostIds,
              (){
                routes.toPreservationsShowPage(
                  context, 
                  bookmarksProvider.currentUserDoc, 
                  bookmarksProvider, 
                  preservatedPostIds, 
                  likedPostIds
                );
              },
              bookmarksProvider.progressNotifier,
              bookmarksProvider.seek,
              bookmarksProvider.currentSongTitleNotifier,
              bookmarksProvider.currentSongPostIdNotifier,
              bookmarksProvider.playButtonNotifier,
              (){
                bookmarksProvider.play();
              },
            (){
              bookmarksProvider.pause();
            },
              bookmarksProvider.currentUserDoc
            ),
          ],
        ),
      ),
    );
  }
}