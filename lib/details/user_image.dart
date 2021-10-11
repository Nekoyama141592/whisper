// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/circle_image.dart';

class UserImage extends StatelessWidget {
  
  const UserImage({
    Key? key,
    required this.padding,
    required this.length,
    required this.userImageURL
  }) : super(key: key);

  final double padding,length;
  final String userImageURL;
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