import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/parts/posts/feeds/feeds_model.dart';
import 'package:whisper/parts/posts/audio_controll/audio_state_design.dart';

import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_title.dart';
import 'package:whisper/parts/posts/audio_controll/current_song_post_id.dart';
import 'package:whisper/parts/comments/comments.dart';
class FeedShowPage extends StatelessWidget{
  final FeedsModel feedsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  FeedShowPage(this.feedsProvider,this.preservatedPostIds,this.likedPostIds);
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
                        child: CurrentSongPostId(feedsProvider.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(feedsProvider.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        feedsProvider.currentUserDoc,
                        feedsProvider.currentSongPostIdNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        feedsProvider.currentSongTitleNotifier,
                        feedsProvider.progressNotifier,
                        feedsProvider.seek,
                        feedsProvider.repeatButtonNotifier,
                        (){
                          feedsProvider.onRepeatButtonPressed();
                        },
                        feedsProvider.isFirstSongNotifier,
                        (){
                          feedsProvider.onPreviousSongButtonPressed();
                        },
                        feedsProvider.playButtonNotifier,
                        (){
                          feedsProvider.play();
                        },
                        (){
                          feedsProvider.pause();
                        },
                        feedsProvider.isLastSongNotifier,
                        (){
                          feedsProvider.onNextSongButtonPressed();
                        }
                      ),
                      Comments(feedsProvider.currentSongPostIdNotifier.value)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      
  }
}