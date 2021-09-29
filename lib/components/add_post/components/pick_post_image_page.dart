import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/details/rounded_button.dart';
import 'package:whisper/components/add_post/components/audio_buttons/upload_button.dart';

class PickPostImagePage extends StatelessWidget {
  PickPostImagePage({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc
  }) : super(key: key);

  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            addPostModel.imageFile != null ? Image.file(addPostModel.imageFile!) : Image.network(currentUserDoc['imageURL']),
            RoundedButton(
              addPostModel.imageFile != null ? '写真を変更する' :'写真を追加(任意)', 
              0.95, 
              20, 
              10, 
              () => null, 
              Colors.white, 
              addPostModel.imageFile != null ? kTertiaryColor : kPrimaryColor
            ),
            UploadButton(addPostModel)
          ],
        ),
      ),
    );
  }
}