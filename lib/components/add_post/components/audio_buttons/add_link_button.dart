// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';

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
      description: 'リンクを追加(任意)', 
      icon: Icon(Icons.add_link,size: 80.0,), 
      press: () { addPostModel.showAddLinkDialogue(context, linkEditingController); },
    );
  }
}