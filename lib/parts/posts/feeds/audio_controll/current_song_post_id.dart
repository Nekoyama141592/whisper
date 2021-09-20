import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

class CurrentSongPostId extends StatelessWidget {
  
  CurrentSongPostId(this.feedsProvider);
  final FeedsModel feedsProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: feedsProvider.currentSongPostIdNotifier, 
      builder: (_, title, __) {
        return Text(
          title, 
          style: TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        );
      }
    );
  }
}