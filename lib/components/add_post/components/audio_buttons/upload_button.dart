// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
//model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

class UploadButton extends StatelessWidget {

  const UploadButton({
    Key? key,
    required this.addPostModel,
    required this.mainModel,
  }) : super(key: key);

  final AddPostModel addPostModel;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      description:  '公開する',
      icon: Icon(
        Icons.upload_file,
        color: Theme.of(context).highlightColor,
        size: 80.0,
      ),
      press: () async {
        await addPostModel.onUploadButtonPressed(context: context, mainModel: mainModel);
      }
    );
  }
}