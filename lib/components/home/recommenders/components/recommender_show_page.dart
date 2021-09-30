// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/comments/comments.dart';
import 'package:whisper/posts/components/audio_state_items/audio_state_design.dart';
import 'package:whisper/posts/components/audio_state_items/current_song_title.dart';
import 'package:whisper/posts/components/audio_state_items/current_song_post_id.dart';
// model
import 'package:whisper/components/home/recommenders/recommenders_model.dart';


class RecommenderShowPage extends StatelessWidget{

  RecommenderShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.recommendersProvider,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersProvider;
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
                        child: CurrentSongPostId(recommendersProvider.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(recommendersProvider.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        recommendersProvider.currentSongPostIdNotifier,
                        recommendersProvider.currentSongDocIdNotifier,
                        recommendersProvider.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        recommendersProvider.currentSongTitleNotifier,
                        recommendersProvider.progressNotifier,
                        recommendersProvider.seek,
                        recommendersProvider.repeatButtonNotifier,
                        (){
                          recommendersProvider.onRepeatButtonPressed();
                        },
                        recommendersProvider.isFirstSongNotifier,
                        (){
                          recommendersProvider.onPreviousSongButtonPressed();
                        },
                        recommendersProvider.playButtonNotifier,
                        (){
                          recommendersProvider.play();
                        },
                        (){
                          recommendersProvider.pause();
                        },
                        recommendersProvider.isLastSongNotifier,
                        (){
                          recommendersProvider.onNextSongButtonPressed();
                        }
                      ),
                      
                    ],
                  ),
                ),
              ),
              Comments(recommendersProvider.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
  }
}