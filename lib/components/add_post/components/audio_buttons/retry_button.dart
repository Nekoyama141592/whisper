// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

class RetryButton extends StatelessWidget {

  RetryButton(this.addPostModel,this.text);
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
        size: 100.0,
      ),
      press: (){
        addPostModel.onRecordAgainButtonPressed();
        addPostModel.resetMeasure();
      }
    );
  }
}