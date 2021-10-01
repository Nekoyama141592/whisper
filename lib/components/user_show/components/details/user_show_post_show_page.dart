// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/details/square_post_image.dart';
import 'package:whisper/posts/components/comments/comments.dart';
// model
import 'package:whisper/components/user_show/user_show_model.dart';


class UserShowPostShowPage extends StatelessWidget {
  
  const UserShowPostShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.userShowModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  });
  
  final UserShowModel userShowModel;
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
                      SquarePostImage(
                        imageURLNotifier: userShowModel.currentSongImageURLNotifier.value.isNotEmpty ? userShowModel.currentSongImageURLNotifier : userShowModel.currentSongUserImageURLNotifier
                      ),
                      Center(
                        child: CurrentSongPostId(userShowModel.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(userShowModel.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        userShowModel.currentSongPostIdNotifier,
                        userShowModel.currentSongDocIdNotifier,
                        userShowModel.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        userShowModel.currentSongTitleNotifier,
                        userShowModel.progressNotifier,
                        userShowModel.seek,
                        userShowModel.repeatButtonNotifier,
                        (){
                          userShowModel.onRepeatButtonPressed();
                        },
                        userShowModel.isFirstSongNotifier,
                        (){
                          userShowModel.onPreviousSongButtonPressed();
                        },
                        userShowModel.playButtonNotifier,
                        (){
                          userShowModel.play();
                        },
                        (){
                          userShowModel.pause();
                        },
                        userShowModel.isLastSongNotifier,
                        (){
                          userShowModel.onNextSongButtonPressed();
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Comments(userShowModel.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
  }
}