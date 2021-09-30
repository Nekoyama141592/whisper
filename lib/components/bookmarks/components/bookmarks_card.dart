import 'package:flutter/material.dart';

import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

import 'package:whisper/constants/routes.dart' as routes;

class BookmarkCard extends StatelessWidget {
  
  BookmarkCard(
    this.bookmarksModel,
    this.preservatedPostIds,
    this.likedPostIds
  );

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
              preservatedPostIds,
              likedPostIds,
              (){
                routes.toPreservationsShowPage(
                  context, 
                  bookmarksModel.currentUserDoc, 
                  bookmarksModel, 
                  preservatedPostIds, 
                  likedPostIds
                );
              },
              bookmarksModel.progressNotifier,
              bookmarksModel.seek,
              bookmarksModel.currentSongTitleNotifier,
              bookmarksModel.currentSongPostIdNotifier,
              bookmarksModel.currentSongUserImageURLNotifier,
              bookmarksModel.playButtonNotifier,
              (){
                bookmarksModel.play();
              },
            (){
              bookmarksModel.pause();
            },
              bookmarksModel.currentUserDoc
            ),
          ],
        ),
      ),
    );
  }
}