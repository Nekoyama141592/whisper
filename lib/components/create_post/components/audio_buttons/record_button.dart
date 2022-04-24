// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/components/create_post/components/audio_buttons/audio_button.dart';
// notifier
import 'package:whisper/components/create_post/components/notifiers/create_post_state_notifier.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/create_post/create_post_model.dart';

class RecordButton extends StatelessWidget {

  const RecordButton({
    Key? key,
    required this.mainModel,
    required this.addPostModel
  }) : super(key: key);

  final MainModel mainModel;
  final CreatePostModel addPostModel;

  @override  
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return 
    ValueListenableBuilder<CreatePostState>(
      valueListenable: addPostModel.addPostStateNotifier,
      builder: (_,value,__) {
        return AudioButton(
          description: value == CreatePostState.recording ?
          l10n.pause
          : l10n.record,
          icon: value == CreatePostState.recording ?
          Icon(Icons.pause, size: addPostIconSize(context: context),)
          : Icon(
            Icons.fiber_manual_record,
            color: Theme.of(context).highlightColor,
            size: addPostIconSize(context: context),
          ),
          press: () async => addPostModel.onRecordButtonPressed(context: context, mainModel: mainModel)
        );
      }
    );
  }
}
