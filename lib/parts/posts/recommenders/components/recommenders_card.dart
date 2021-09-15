import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';
import '../audio_controll/audio_window.dart';

import 'package:whisper/parts/posts/components/post_card.dart';

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
        AudioWindow(currentUserDoc,recommendersProvider, preservatedPostIds, likedPostIds)
      ]
    );
  }
}