import 'package:flutter/material.dart';

import 'package:whisper/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/add_post/add_post_model.dart';

class RecordButton extends StatelessWidget {

  RecordButton(this.addPostProvider);
  final AddPostModel addPostProvider;
  @override  
  Widget build(BuildContext context) {
    return 
    AudioButton(
      addPostProvider.isRecording ?
      '停止する'
      : '録音する',
      addPostProvider.isRecording ?
      Icon(Icons.pause)
      : Icon(Icons.fiber_manual_record),
      () async {
        addPostProvider.onRecordButtonPressed(context);
      }
    );
  }
}