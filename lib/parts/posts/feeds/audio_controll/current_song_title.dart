import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/feeds/feeds_model.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.feedsProvider);
  final FeedsModel feedsProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: feedsProvider.currentSongTitleNotifier, 
      builder: (_, title, __) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(title, style: TextStyle(fontSize: 20)),
        );
      }
    );
  }
}