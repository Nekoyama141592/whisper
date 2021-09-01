import 'package:flutter/material.dart';
import 'package:whisper/preservations/preservations_model.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.preservationsProvider);
  final PreservationsModel preservationsProvider;
  @override  
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: preservationsProvider.currentSongTitleNotifier, 
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