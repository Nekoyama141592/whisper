// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';

class AudioWindowUserImage extends StatelessWidget {

  const AudioWindowUserImage({
    Key? key,
    required this.currentSongDocNotifier,
    required this.mainModel
  }) : super(key: key);
  
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return RedirectUserImage(userImageURL: currentSongDoc!['userImageURL'], length: 40.0, padding: 5.0,passiveUserDocId: currentSongDoc['userDocId'],mainModel: mainModel,);
      }
    );
  }
}