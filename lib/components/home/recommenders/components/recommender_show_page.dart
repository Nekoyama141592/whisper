// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/comments/comments.dart';
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
import 'package:whisper/posts/components/details/square_post_image.dart';
// model
import 'package:whisper/components/home/recommenders/recommenders_model.dart';


class RecommenderShowPage extends StatelessWidget{

  RecommenderShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.recommendersModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersModel;
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
                  child: Column(
                    children: [
                      SquarePostImage(
                        imageURLNotifier: recommendersModel.currentSongImageURLNotifier.value.isNotEmpty ? recommendersModel.currentSongImageURLNotifier : recommendersModel.currentSongUserImageURLNotifier
                      ),
                      Center(
                        // image
                        child: CurrentSongPostId(recommendersModel.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(recommendersModel.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        recommendersModel.currentSongPostIdNotifier,
                        recommendersModel.currentSongDocIdNotifier,
                        recommendersModel.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        recommendersModel.currentSongTitleNotifier,
                        recommendersModel.progressNotifier,
                        recommendersModel.seek,
                        recommendersModel.repeatButtonNotifier,
                        (){
                          recommendersModel.onRepeatButtonPressed();
                        },
                        recommendersModel.isFirstSongNotifier,
                        (){
                          recommendersModel.onPreviousSongButtonPressed();
                        },
                        recommendersModel.playButtonNotifier,
                        (){
                          recommendersModel.play();
                        },
                        (){
                          recommendersModel.pause();
                        },
                        recommendersModel.isLastSongNotifier,
                        (){
                          recommendersModel.onNextSongButtonPressed();
                        }
                      ),
                      
                    ],
                  ),
                ),
              ),
              Comments(recommendersModel.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
  }
}