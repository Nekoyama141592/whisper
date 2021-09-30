// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/circle_image.dart';

class UserImage extends StatelessWidget {
  
  const UserImage({
    Key? key,
    required this.userImageURL,
    required this.length,
    required this.padding
  }) : super(key: key);

  final String userImageURL;
  final double length;
  final double padding;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: CircleImage(
        length: length, 
        image: NetworkImage(userImageURL)
      ),
    );
  }
}