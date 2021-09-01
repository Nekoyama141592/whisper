import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';
import '../audio_controll/audio_state_design.dart';

class PostCard extends StatelessWidget{
  PostCard(this.recommendersProvider,this.preservatedPostIds);
  final RecommendersModel recommendersProvider;
  final List preservatedPostIds;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: recommendersProvider.recommenderDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              ListTile(
                title: Text(recommendersProvider.recommenderDocs[i]['title']),
                
              )
          ),
        ),
        AudioStateDesign(recommendersProvider,preservatedPostIds)
      ]
    );
  }
}