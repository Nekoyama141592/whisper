// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';

class SquarePostImage extends StatelessWidget {

  const SquarePostImage({
    Key? key,
    required this.currentSongMapNotifier,
  }) : super(key: key);

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;

  @override 
  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        final String imageURL = currentSongMap[imageURLKey];
        final String resultURL = imageURL.isNotEmpty ? currentSongMap[imageURLKey] : currentSongMap[userImageURLKey];
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 35.0
          ),
          child: Center(
            child: Container(
              width: length,
              height: length,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).highlightColor
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(resultURL),
                )
              ),
            ),
          ),
        );
      }
    );
  }
}