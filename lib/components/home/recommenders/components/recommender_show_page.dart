import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/components/home/recommenders/recommenders_model.dart';

import 'package:whisper/posts/components/post_buttons/post_buttons.dart';

import 'package:whisper/parts/comments/comments.dart';
import 'package:whisper/posts/components/audio_state_design.dart';
import 'package:whisper/posts/components/current_song_title.dart';
import 'package:whisper/posts/components/current_song_post_id.dart';
class RecommenderShowPage extends StatelessWidget{

  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  RecommenderShowPage(
    this.currentUserDoc,
    this.recommendersProvider,
    this.preservatedPostIds,
    this.likedPostIds
  );
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