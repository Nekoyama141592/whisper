import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/components/home/recommenders/recommenders_model.dart';
import 'package:whisper/parts/posts/audio_controll/audio_window.dart';

import 'package:whisper/parts/posts/components/post_card.dart';
import 'package:whisper/constants/routes.dart' as routes;

class RecommendersCard extends StatelessWidget{
  RecommendersCard(this.currentUserDoc,this.recommendersProvider,this.preservatedPostIds,this.likedPostIds);
  
  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: recommendersProvider.recommenderDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(
                recommendersProvider.recommenderDocs[i]
              )
          ),
        ),
        AudioWindow(
          preservatedPostIds,
          likedPostIds,
          (){
            routes.toRecommenderShowPage(context, currentUserDoc,recommendersProvider, preservatedPostIds, likedPostIds);
          },
          recommendersProvider.progressNotifier,
          recommendersProvider.seek,
          recommendersProvider.currentSongTitleNotifier,
          recommendersProvider.currentSongPostIdNotifier,
          recommendersProvider.playButtonNotifier,
          (){
            recommendersProvider.play();
          },
         (){
           recommendersProvider.pause();
         },
          currentUserDoc
        ),
      ]
    );
  }
}