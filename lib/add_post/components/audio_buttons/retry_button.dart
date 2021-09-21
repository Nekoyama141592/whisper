import 'package:flutter/material.dart';

import 'package:whisper/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/add_post/add_post_model.dart';

class RetryButton extends StatelessWidget {

  RetryButton(this.addPostProvider);
  final AddPostModel addPostProvider;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      'リトライ',
      Icon(Icons.replay),
      (){addPostProvider.onRecordAgainButtonPressed();}
    );
  }
}