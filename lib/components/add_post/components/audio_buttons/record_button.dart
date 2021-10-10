// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// notifier
import 'package:whisper/components/add_post/components/notifiers/add_post_state_notifier.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

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
            color: Theme.of(context).highlightColor,
          ),
          () async {
            addPostProvider.onRecordButtonPressed(context);
          }
        );
      }
    );
  }
}
