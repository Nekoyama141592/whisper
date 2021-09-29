import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';

class RetryButton extends StatelessWidget {

  RetryButton(this.addPostModel,this.text);
  final AddPostModel addPostModel;
  final String text;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      text,
      Icon(
        Icons.replay,
        color: kTertiaryColor,
      ),
      (){
        addPostModel.onRecordAgainButtonPressed();
        addPostModel.resetMeasure();
      }
    );
  }
}