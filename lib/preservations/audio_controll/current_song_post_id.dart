import 'package:flutter/material.dart';

import 'package:whisper/preservations/preservations_model.dart';

class CurrentSongPostId extends StatelessWidget {
  
  CurrentSongPostId(this.preservationsProvider);
  final PreservationsModel preservationsProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: preservationsProvider.currentSongPostIdNotifier, 
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