// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/circle_image.dart';
// model
import 'package:whisper/main_model.dart';

class UserImage extends StatelessWidget {
  
  const UserImage({
    Key? key,
    required this.padding,
    required this.length,
    required this.userImageURL,
    required this.mainModel,
    required this.uid
  }) : super(key: key);

  final double padding,length;
  final String userImageURL;
  final String uid;
  final MainModel mainModel;
  @override 
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      child: CircleImage(
        length: length, 
        image: NetworkImage(
          mainModel.currentWhisperUser.uid == uid ? mainModel.currentWhisperUser.userImageURL : userImageURL
        )
      ),
    );
  }
}