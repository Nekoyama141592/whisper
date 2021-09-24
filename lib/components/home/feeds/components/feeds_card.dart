import 'package:flutter/material.dart';
import 'package:whisper/components/home/feeds/feeds_model.dart';

import 'package:whisper/posts/components/audio_state_items/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/constants/routes.dart' as routes;

class FeedsCard extends StatelessWidget{
  FeedsCard(this.feedsProvider,this.preservatedPostIds,this.likedPostIds);
  final FeedsModel feedsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: feedsProvider.feedDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(feedsProvider.feedDocs[i])
          ),
        ),
        AudioWindow(
          preservatedPostIds,
          likedPostIds,
          (){
            routes.toFeedShowPage(context, feedsProvider, preservatedPostIds, likedPostIds);
          },
          feedsProvider.progressNotifier,
          feedsProvider.seek,
          feedsProvider.currentSongTitleNotifier,
          feedsProvider.currentSongPostIdNotifier,
          feedsProvider.playButtonNotifier,
          (){
            feedsProvider.play();
          },
         (){
           feedsProvider.pause();
         },
          feedsProvider.currentUserDoc
        ),
       
      ]
    );
  }
}