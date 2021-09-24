import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/bookmarks/bookmarks_model.dart';

import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';
import 'package:whisper/parts/posts/audio_controll/audio_state_design.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_title.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_post_id.dart';
import 'package:whisper/parts/comments/comments.dart';


class BookmarkShowPage extends StatelessWidget{
  final DocumentSnapshot currentUserDoc;
  final BookMarksModel bookmarksProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  BookmarkShowPage(this.currentUserDoc,this.bookmarksProvider,this.preservatedPostIds,this.likedPostIds);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        extendBodyBehindAppBar: false,
        
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    
                  ),
                  color: Colors.blue,
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  // margin: EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Center(
                        // image
                        child: CurrentSongPostId(bookmarksProvider.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(bookmarksProvider.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        bookmarksProvider.currentSongPostIdNotifier,
                        bookmarksProvider.currentSongDocIdNotifier,
                        bookmarksProvider.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        bookmarksProvider.currentSongTitleNotifier,
                        bookmarksProvider.progressNotifier,
                        bookmarksProvider.seek,
                        bookmarksProvider.repeatButtonNotifier,
                        (){
                          bookmarksProvider.onRepeatButtonPressed();
                        },
                        bookmarksProvider.isFirstSongNotifier,
                        (){
                          bookmarksProvider.onPreviousSongButtonPressed();
                        },
                        bookmarksProvider.playButtonNotifier,
                        (){
                          bookmarksProvider.play();
                        },
                        (){
                          bookmarksProvider.pause();
                        },
                        bookmarksProvider.isLastSongNotifier,
                        (){
                          bookmarksProvider.onNextSongButtonPressed();
                        }
                      ),
                      
                    ],
                  ),
                ),
              ),
              Comments(bookmarksProvider.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
      
  }
}