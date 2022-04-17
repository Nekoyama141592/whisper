// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/l10n/l10n.dart';
//model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/add_post/add_post_model.dart';

class UploadButton extends StatelessWidget {

  const UploadButton({
    Key? key,
    required this.addPostModel,
    required this.mainModel,
  }) : super(key: key);

  final AddPostModel addPostModel;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return 
    AudioButton(
      description: l10n.upload,
      icon: Icon(
        Icons.upload_file,
        color: Theme.of(context).highlightColor,
        size: addPostIconSize(context: context),
      ),
      press: () async => await addPostModel.onUploadButtonPressed(context: context, mainModel: mainModel)
    );
  }
}