// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
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
        final result = fromMapToPost(postMap: currentSongMap);
        return RedirectUserImage(userImageURL: result.userImageURL, length: 40.0, padding: 5.0,passiveUserDocId: result.uid,mainModel: mainModel,);
      }
    );
  }
}