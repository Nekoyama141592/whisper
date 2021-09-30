// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/user_image.dart';

class AudioWindowUserImage extends StatelessWidget {

  const AudioWindowUserImage({
    Key? key,
    required this.currentSongUserImageURLNotifier
  }) : super(key: key);
  
  final ValueNotifier<String> currentSongUserImageURLNotifier;
  
  @override 
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentSongUserImageURLNotifier, 
      builder: (_,userImageURL,__) {
        return UserImage(userImageURL: userImageURL, length: 40.0, padding: 5.0);
      }
    );
  }
}