// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/circle_image.dart';

class UserImage extends StatelessWidget {
  
  const UserImage({
    Key? key,
    required this.userImageURL,
  }) : super(key: key);

  final String userImageURL;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: CircleImage(
        length: 60.0, 
        image: NetworkImage(userImageURL)
      ),
    );
  }
}