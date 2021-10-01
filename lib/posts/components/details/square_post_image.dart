// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class SquarePostImage extends StatelessWidget {

  const SquarePostImage({
    Key? key,
    required this.currentSongDocNotifier,
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;

  @override 
  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        final String imageURL = currentSongDoc!['imageURL'];
        final String resultURL = imageURL.isNotEmpty ? currentSongDoc['imageURL'] : currentSongDoc['userImageURL'];
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