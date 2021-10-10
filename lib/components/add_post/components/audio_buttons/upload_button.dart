// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
//model
import 'package:whisper/components/add_post/add_post_model.dart';

class UploadButton extends StatelessWidget {

  const UploadButton({
    Key? key,
    required this.addPostModel,
    required this.currentUserDoc
  }) : super(key: key);

  final AddPostModel addPostModel;
  final DocumentSnapshot currentUserDoc;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      '公開する',
      Icon(
        Icons.upload_file,
        color: Theme.of(context).highlightColor,
      ),
      () async {
        await addPostModel.onUploadButtonPressed(context,currentUserDoc);
      }
    );
  }
}