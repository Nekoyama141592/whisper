import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

class CurrentSongPostId extends StatelessWidget {
  
  CurrentSongPostId(this.recommendersProvider);
  final RecommendersModel recommendersProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: recommendersProvider.currentSongPostIdNotifier, 
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