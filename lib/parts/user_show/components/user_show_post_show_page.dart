import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/parts/user_show/user_show_model.dart';
import 'package:whisper/parts/posts/audio_controll/audio_state_design.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_title.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_post_id.dart';
import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';

import 'package:whisper/parts/comments/comments.dart';

class UserShowPostShowPage extends StatelessWidget {
  UserShowPostShowPage(this.currentUserDoc,this.userShowProvider,this.preservatedPostIds,this.likedPostIds);
  
  final UserShowModel userShowProvider;
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
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
                        child: CurrentSongPostId(userShowProvider.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(userShowProvider.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        userShowProvider.currentSongPostIdNotifier,
                        userShowProvider.currentSongDocIdNotifier,
                        userShowProvider.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        userShowProvider.currentSongTitleNotifier,
                        userShowProvider.progressNotifier,
                        userShowProvider.seek,
                        userShowProvider.repeatButtonNotifier,
                        (){
                          userShowProvider.onRepeatButtonPressed();
                        },
                        userShowProvider.isFirstSongNotifier,
                        (){
                          userShowProvider.onPreviousSongButtonPressed();
                        },
                        userShowProvider.playButtonNotifier,
                        (){
                          userShowProvider.play();
                        },
                        (){
                          userShowProvider.pause();
                        },
                        userShowProvider.isLastSongNotifier,
                        (){
                          userShowProvider.onNextSongButtonPressed();
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Comments(userShowProvider.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
  }
}