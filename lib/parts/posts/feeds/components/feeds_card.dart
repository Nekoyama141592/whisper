import 'package:flutter/material.dart';
import 'package:whisper/parts/posts/feeds/feeds_model.dart';

import 'package:whisper/parts/posts/feeds/audio_controll/audio_window.dart';
import 'package:whisper/parts/posts/components/post_card.dart';


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
        AudioWindow(feedsProvider, preservatedPostIds, likedPostIds),
       
      ]
    );
  }
}