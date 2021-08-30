import 'package:flutter/material.dart';
import 'package:whisper/preservations/preservations_model.dart';

class CurrentSongTitle extends StatelessWidget {
  
  CurrentSongTitle(this.preservationsProvider);
  final PreservationsModel preservationsProvider;
  @override  
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(child: Text(preservationsProvider.currentSongDoc['title'])),
    );
  }
}