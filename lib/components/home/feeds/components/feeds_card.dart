// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// model
import 'package:whisper/components/home/feeds/feeds_model.dart';

class FeedsCard extends StatelessWidget{
  
  const FeedsCard({
    Key? key,
    required this.feedsModel,
    required this.preservatedPostIds,
    required this.likedPostIds
    }) : super(key: key);
  
  final FeedsModel feedsModel;
  final List preservatedPostIds;
  final List likedPostIds;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: feedsModel.feedDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(postDoc: feedsModel.feedDocs[i])
          ),
        ),
        AudioWindow(
          preservatedPostIds: preservatedPostIds, 
          likedPostIds: likedPostIds, 
          route: (){
            routes.toPostShowPage(
            context, 
            likedPostIds, 
            preservatedPostIds, 
            feedsModel.currentUserDoc, 
            feedsModel.currentSongDocNotifier, 
            feedsModel.progressNotifier, 
            feedsModel.seek, 
            feedsModel.repeatButtonNotifier, 
            () { feedsModel.onRepeatButtonPressed(); }, 
            feedsModel.isFirstSongNotifier, 
            () { feedsModel.onPreviousSongButtonPressed(); }, 
            feedsModel.playButtonNotifier, 
            () { feedsModel.play(); }, 
            () { feedsModel.pause(); }, 
            feedsModel.isLastSongNotifier, 
            () { feedsModel.onNextSongButtonPressed(); }
            );
          },
          progressNotifier: feedsModel.progressNotifier, 
          seek: feedsModel.seek, 
          currentSongDocNotifier: feedsModel.currentSongDocNotifier, 
          playButtonNotifier: feedsModel.playButtonNotifier,
          play: () {
            feedsModel.play();
          }, 
          pause: () {
            feedsModel.pause();
          }, 
          currentUserDoc: feedsModel.currentUserDoc
        )
       
      ]
    );
  }
}