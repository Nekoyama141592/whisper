import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/components/post_card.dart';
import 'package:whisper/preservations/audio_controll/audio_window.dart';
import 'package:whisper/parts/components/nothing.dart';
import 'package:whisper/parts/components/loading.dart';
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
    return Container(
      child: 
      preservationsProvider.isLoading ?
      Loading()
      : preservationsProvider.preservationDocs.isEmpty ?
      Nothing()
      : 
      Padding(
        padding: const EdgeInsets.only(top:20,),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: preservationsProvider.preservationDocs.length,
                itemBuilder: (BuildContext context, int i) =>
                  PostCard(preservationsProvider.preservationDocs[i])
              ),
            ),
            AudioWindow(
              preservationsProvider.currentUserDoc,
              preservationsProvider,
              preservatedPostIds,
              likedPostIds
            )
          ],
        ),
      ),
    );
  }
}