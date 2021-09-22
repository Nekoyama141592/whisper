import 'package:flutter/material.dart';

import 'package:whisper/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/add_post/add_post_model.dart';

class RetryButton extends StatelessWidget {

  RetryButton(this.addPostProvider,this.text);
  final AddPostModel addPostProvider;
  final String text;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      text,
      Icon(Icons.replay),
      (){
        addPostProvider.onRecordAgainButtonPressed();
        addPostProvider.resetButtonPressed();
      }
    );
  }
}