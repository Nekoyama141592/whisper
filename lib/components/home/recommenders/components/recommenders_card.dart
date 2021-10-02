// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// components
import 'package:whisper/posts/components/details/post_card.dart';
import 'package:whisper/posts/components/audio_window/audio_window.dart';
// model
import 'package:whisper/components/home/recommenders/recommenders_model.dart';



class RecommendersCard extends StatelessWidget{
  const RecommendersCard({
    Key? key,
    required this.currentUserDoc,
    required this.recommendersModel,
    required this.preservatedPostIds,
    required this.likedPostIds
  }) : super(key: key);
  
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
            routes.toPostShowPage(
            context, 
            likedPostIds, 
            preservatedPostIds, 
            currentUserDoc, 
            recommendersModel.currentSongDocNotifier, 
            recommendersModel.progressNotifier, 
            recommendersModel.seek, 
            recommendersModel.repeatButtonNotifier, 
            () { recommendersModel.onRepeatButtonPressed(); }, 
            recommendersModel.isFirstSongNotifier, 
            () { recommendersModel.onPreviousSongButtonPressed(); }, 
            recommendersModel.playButtonNotifier, 
            () { recommendersModel.play(); }, 
            () { recommendersModel.pause(); }, 
            recommendersModel.isLastSongNotifier, 
            () { recommendersModel.onNextSongButtonPressed(); }
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