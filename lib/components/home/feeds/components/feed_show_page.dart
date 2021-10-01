// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/posts/components/audio_window/components/audio_state_design.dart';
import 'package:whisper/posts/components/post_buttons/post_buttons.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_title.dart';
import 'package:whisper/posts/components/audio_window/components/current_song_post_id.dart';
import 'package:whisper/posts/components/details/square_post_image.dart';
import 'package:whisper/posts/components/comments/comments.dart';
// model
import 'package:whisper/components/home/feeds/feeds_model.dart';

class FeedShowPage extends StatelessWidget{
  
  const FeedShowPage({
    required this.feedsModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  });

  final FeedsModel feedsModel;
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
                        imageURLNotifier: feedsModel.currentSongImageURLNotifier.value.isNotEmpty ? feedsModel.currentSongImageURLNotifier : feedsModel.currentSongUserImageURLNotifier
                      ),
                      Center(
                        child: CurrentSongPostId(feedsModel.currentSongPostIdNotifier),
                      ),
                      Center(
                        child: CurrentSongTitle(feedsModel.currentSongTitleNotifier),
                      ),
                      PostButtons(
                        feedsModel.currentUserDoc,
                        feedsModel.currentSongPostIdNotifier,
                        feedsModel.currentSongDocIdNotifier,
                        feedsModel.currentSongCommentsNotifier,
                        preservatedPostIds,
                        likedPostIds
                      ),
                      AudioStateDesign(
                        preservatedPostIds,
                        likedPostIds,
                        feedsModel.currentSongTitleNotifier,
                        feedsModel.progressNotifier,
                        feedsModel.seek,
                        feedsModel.repeatButtonNotifier,
                        (){
                          feedsModel.onRepeatButtonPressed();
                        },
                        feedsModel.isFirstSongNotifier,
                        (){
                          feedsModel.onPreviousSongButtonPressed();
                        },
                        feedsModel.playButtonNotifier,
                        (){
                          feedsModel.play();
                        },
                        (){
                          feedsModel.pause();
                        },
                        feedsModel.isLastSongNotifier,
                        (){
                          feedsModel.onNextSongButtonPressed();
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Comments(feedsModel.currentSongCommentsNotifier)
            ],
          ),
        ),
      );
      
  }
}