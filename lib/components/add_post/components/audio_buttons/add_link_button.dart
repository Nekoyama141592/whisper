// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';

class AddLinkButton extends StatelessWidget {

  const AddLinkButton({
    Key? key,
    required this.addPostModel
  }) : super(key: key);

  final AddPostModel addPostModel;

  @override 
  
  Widget build(BuildContext context) {

    return ValueListenableBuilder<List<WhisperLink>>(
      valueListenable: addPostModel.whisperLinksNotifier,
      builder: (_,whisperLinks,__) {
        return AudioButton(
          description: whisperLinks.isEmpty ? 'リンクを追加(任意)' : 'リンクを変更',
          icon: whisperLinks.isEmpty ?
          Icon(
            Icons.add_link,
            size: addPostIconSize(context: context),
          )
          : Icon(
            Icons.link,
            color: Theme.of(context).highlightColor,
            size: addPostIconSize(context: context),
          ),
          press: () { addPostModel.initLinks(context: context); },
        );
      }
    );
  }
}