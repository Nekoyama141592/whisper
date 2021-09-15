import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/components/post_card.dart';
import 'package:whisper/preservations/audio_controll/audio_window.dart';
import 'package:whisper/preservations/preservations_model.dart';
class PreservationCard extends StatelessWidget {
  
  PreservationCard(
    this.preservationsProvider,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  final List likedPostIds;

  @override 
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: preservationsProvider.preservationDocs.length,
            itemBuilder: (BuildContext context, int i) =>
              PostCard(preservationsProvider.preservationDocs[i])
          ),
        ),
        AudioWindow(
          preservationsProvider.currentSongDoc,
          preservationsProvider,
          preservatedPostIds,
          likedPostIds
        )
      ],
    );
  }
}