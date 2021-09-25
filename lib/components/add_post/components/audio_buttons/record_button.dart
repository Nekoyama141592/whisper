import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';

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
      : Icon(
        Icons.fiber_manual_record,
        color: kTertiaryColor,
      ),
      () async {
        addPostProvider.onRecordButtonPressed(context);
      }
    );
  }
}
