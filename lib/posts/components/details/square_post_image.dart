// material
import 'package:flutter/material.dart';
// domain
import 'package:whisper/domain/post/post.dart';

class SquarePostImage extends StatelessWidget {

  const SquarePostImage({
    Key? key,
    required this.whisperPost
  }) : super(key: key);

  final Post whisperPost;

  @override 
  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final length = size.width * 0.8;
    final String imageURL = whisperPost.imageURLs.first;
    final String resultURL = imageURL.isNotEmpty ? whisperPost.imageURLs.first : whisperPost.userImageURL;
    
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
}