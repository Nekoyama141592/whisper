import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/preservations/preservations_model.dart';

import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';
import 'package:whisper/parts/posts/audio_controll/audio_state_design.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_title.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_post_id.dart';
import 'package:whisper/parts/comments/comments.dart';


class PreservationShowPage extends StatelessWidget{
  final DocumentSnapshot currentUserDoc;
  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  PreservationShowPage(this.currentUserDoc,this.preservationsProvider,this.preservatedPostIds,this.likedPostIds);
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
                        child: CurrentSongPostId(preservationsProvider.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(preservationsProvider.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        currentUserDoc,
                        preservationsProvider.currentSongPostIdNotifier,
                        preservationsProvider.currentSongDocIdNotifier,
                        preservationsProvider.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        preservationsProvider.currentSongTitleNotifier,
                        preservationsProvider.progressNotifier,
                        preservationsProvider.seek,
                        preservationsProvider.repeatButtonNotifier,
                        (){
                          preservationsProvider.onRepeatButtonPressed();
                        },
                        preservationsProvider.isFirstSongNotifier,
                        (){
                          preservationsProvider.onPreviousSongButtonPressed();
                        },
                        preservationsProvider.playButtonNotifier,
                        (){
                          preservationsProvider.play();
                        },
                        (){
                          preservationsProvider.pause();
                        },
                        preservationsProvider.isLastSongNotifier,
                        (){
                          preservationsProvider.onNextSongButtonPressed();
                        }
                      ),
                      
                    ],
                  ),
                ),
              ),
              Comments(preservationsProvider.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
      
  }
}