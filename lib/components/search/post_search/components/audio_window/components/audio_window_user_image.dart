// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';

class AudioWindowUserImage extends StatelessWidget {

  const AudioWindowUserImage({
    Key? key,
    required this.currentSongMapNotifier,
    required this.mainModel
  }) : super(key: key);
  
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        return RedirectUserImage(userImageURL: currentSongMap['userImageURL'], length: 40.0, padding: 5.0,passiveUserDocId: currentSongMap['userDocId'],mainModel: mainModel,);
      }
    );
  }
}