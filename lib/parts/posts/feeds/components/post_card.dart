import 'package:flutter/material.dart';
import 'package:whisper/parts/posts/feeds/feeds_model.dart';

import '../audio_controll/audio_state_design.dart';

class PostCard extends StatelessWidget{
  PostCard(this.feedsProvider,this.preservatedPostIds,this.likedPostIds);
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
              ListTile(
                title: Text(feedsProvider.feedDocs[i]['title']),
                
              )
          ),
        ),
        AudioStateDesign(feedsProvider,preservatedPostIds,likedPostIds)
      ]
    );
  }
}