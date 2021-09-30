import 'package:flutter/material.dart';
import 'package:whisper/components/home/feeds/feeds_model.dart';

import 'package:whisper/posts/components/audio_window/audio_window.dart';
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/constants/routes.dart' as routes;

class FeedsCard extends StatelessWidget{
  FeedsCard(this.feedsModel,this.preservatedPostIds,this.likedPostIds);
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
          preservatedPostIds,
          likedPostIds,
          (){
            routes.toFeedShowPage(context, feedsModel, preservatedPostIds, likedPostIds);
          },
          feedsModel.progressNotifier,
          feedsModel.seek,
          feedsModel.currentSongTitleNotifier,
          feedsModel.currentSongPostIdNotifier,
          feedsModel.currentSongUserImageURLNotifier,
          feedsModel.playButtonNotifier,
          (){
            feedsModel.play();
          },
         (){
           feedsModel.pause();
         },
          feedsModel.currentUserDoc
        ),
       
      ]
    );
  }
}