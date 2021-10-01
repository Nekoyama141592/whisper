import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/components/home/recommenders/recommenders_model.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';

import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/constants/routes.dart' as routes;

class RecommendersCard extends StatelessWidget{
  RecommendersCard(this.currentUserDoc,this.recommendersModel,this.preservatedPostIds,this.likedPostIds);
  
  final DocumentSnapshot currentUserDoc;
  final RecommendersModel recommendersModel;
  final List preservatedPostIds;
  final List likedPostIds;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: recommendersModel.recommenderDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(
                postDoc: recommendersModel.recommenderDocs[i]
              )
          ),
        ),
        AudioWindow(
          preservatedPostIds: preservatedPostIds, 
          likedPostIds: likedPostIds, 
          route: (){
            routes.toPreservationsShowPage(
              context, 
              currentUserDoc, 
              recommendersModel, 
              preservatedPostIds, 
              likedPostIds
            );
          },
          progressNotifier: recommendersModel.progressNotifier, 
          seek: recommendersModel.seek, 
          currentSongDocNotifier: recommendersModel.currentSongDocNotifier, 
          playButtonNotifier: recommendersModel.playButtonNotifier,
          play: () {
            recommendersModel.play();
          }, 
          pause: () {
            recommendersModel.pause();
          }, 
          currentUserDoc: currentUserDoc
        )
      ]
    );
  }
}