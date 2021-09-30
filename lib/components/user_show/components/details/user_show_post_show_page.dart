// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/comments/comments.dart';
// model
import 'package:whisper/components/user_show/user_show_model.dart';


class UserShowPostShowPage extends StatelessWidget {
  
  const UserShowPostShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.userShowProvider,
    required this.preservatedPostIds,
    required this.likedPostIds
  });
  
  final UserShowModel userShowProvider;
  final DocumentSnapshot currentUserDoc;
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