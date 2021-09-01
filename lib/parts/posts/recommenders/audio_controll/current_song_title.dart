import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/recommenders/recommenders_model.dart';

class CurrentSongTitle extends StatelessWidget {
  CurrentSongTitle(this.recommendersProvider);
  final RecommendersModel recommendersProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: recommendersProvider.currentSongTitleNotifier, 
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: TextStyle(fontSize: 20)),
        );
      }
    );
  }
}