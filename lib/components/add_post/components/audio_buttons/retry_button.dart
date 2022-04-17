// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

class RetryButton extends StatelessWidget {

  RetryButton({ Key? key,required this.addPostModel, required this.text}) : super(key: key);
  final AddPostModel addPostModel;
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