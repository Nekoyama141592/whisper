// material
import 'package:flutter/material.dart';

class SquarePostImage extends StatelessWidget {

  const SquarePostImage({
    Key? key,
    required this.imageURLNotifier
  }) : super(key: key);

  final ValueNotifier<String> imageURLNotifier;
  @override 
  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    return ValueListenableBuilder<String>(
      valueListenable: imageURLNotifier, 
      builder: (_,imageURL,__) {
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
                  image: NetworkImage(imageURL),
                )
              ),
            ),
          ),
        );
      }
    );
  }
}