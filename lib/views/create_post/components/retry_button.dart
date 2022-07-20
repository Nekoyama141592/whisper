// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/views/create_post/components/audio_button.dart';
// model
import 'package:whisper/models/main/create_post_model.dart';

class RetryButton extends StatelessWidget {

  RetryButton({ Key? key,required this.addPostModel, required this.text}) : super(key: key);
  final CreatePostModel addPostModel;
  final String text;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      description: text,
      icon: Icon(
        Icons.replay,
        color: Theme.of(context).highlightColor,
        size: addPostIconSize(context: context),
      ),
      press: (){
        addPostModel.onRecordAgainButtonPressed();
        addPostModel.resetMeasure();
      }
    );
  }
}