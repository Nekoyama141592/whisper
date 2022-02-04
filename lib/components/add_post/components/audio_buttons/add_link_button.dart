// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/doubles.dart';

class AddLinkButton extends StatelessWidget {

  const AddLinkButton({
    Key? key,
    required this.addPostModel
  }) : super(key: key);

  final AddPostModel addPostModel;

  @override 
  
  Widget build(BuildContext context) {

    final linkEditingController = TextEditingController(text: addPostModel.link);

    return AudioButton(
      description: addPostModel.link.isEmpty ? 'リンクを追加(任意)' : 'リンクを変更',
      icon: addPostModel.link.isEmpty ?
      Icon(
        Icons.add_link,
        size: addPostIconSize(context: context),
      )
      : Icon(
        Icons.link,
        color: Theme.of(context).highlightColor,
        size: addPostIconSize(context: context),
      ),
      press: () { addPostModel.showAddLinkDialogue(context, linkEditingController); },
    );
  }
}