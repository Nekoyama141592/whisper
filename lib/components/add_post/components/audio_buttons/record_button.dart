import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';

class RecordButton extends StatelessWidget {

  RecordButton(this.addPostProvider);
  final AddPostModel addPostProvider;
  @override  
  Widget build(BuildContext context) {
    return 
    ValueListenableBuilder<AddPostState>(
      valueListenable: addPostProvider.addPostStateNotifier,
      builder: (_,value,__) {
        return AudioButton(
          value == AddPostState.recording ?
          '停止する'
          : '録音する',
          value == AddPostState.recording ?
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
    );
  }
}
