import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/preservations/preservations_model.dart';

import 'package:whisper/parts/posts/post_buttons/post_buttons.dart';
import 'package:whisper/preservations/audio_controll/audio_state_design.dart';

class PreservationShowPage extends StatelessWidget{
  final DocumentSnapshot doc;
  final PreservationsModel preservationsProvider;
  final List preservatedPostIds;
  final List likedPostIds;
  PreservationShowPage(this.doc,this.preservationsProvider,this.preservatedPostIds,this.likedPostIds);
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        backgroundColor: kBackgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10
              ),
              child: IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: (){
                  Navigator.pop(context);
                }, 
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  // image
                  child: Text(doc.id),
                ),
                Center(
                  child: Text(doc['title']),
                ),
                PostButtons(
                  preservationsProvider.currentUser!.uid,
                  doc,
                  preservatedPostIds,
                  likedPostIds
                ),
                
                AudioStateDesign(preservationsProvider,preservatedPostIds,likedPostIds)
              ],
            ),
          ],
        ),
      );
      
  }
}