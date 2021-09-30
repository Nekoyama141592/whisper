// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/audio_state_items/audio_state_design.dart';
import 'package:whisper/posts/components/audio_state_items/current_song_title.dart';
import 'package:whisper/posts/components/audio_state_items/current_song_post_id.dart';
import 'package:whisper/posts/components/comments/comments.dart';
// model
import 'package:whisper/components/bookmarks/bookmarks_model.dart';



class BookmarkShowPage extends StatelessWidget{
  const BookmarkShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.bookmarksModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final BookMarksModel bookmarksModel;
  final List preservatedPostIds;
  final List likedPostIds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        child: CurrentSongPostId(bookmarksModel.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(bookmarksModel.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        bookmarksModel.currentSongPostIdNotifier,
                        bookmarksModel.currentSongDocIdNotifier,
                        bookmarksModel.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        bookmarksModel.currentSongTitleNotifier,
                        bookmarksModel.progressNotifier,
                        bookmarksModel.seek,
                        bookmarksModel.repeatButtonNotifier,
                        (){
                          bookmarksModel.onRepeatButtonPressed();
                        },
                        bookmarksModel.isFirstSongNotifier,
                        (){
                          bookmarksModel.onPreviousSongButtonPressed();
                        },
                        bookmarksModel.playButtonNotifier,
                        (){
                          bookmarksModel.play();
                        },
                        (){
                          bookmarksModel.pause();
                        },
                        bookmarksModel.isLastSongNotifier,
                        (){
                          bookmarksModel.onNextSongButtonPressed();
                        }
                      ),
                      
                    ],
                  ),
                ),
              ),
              Comments(bookmarksModel.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
      
  }
}