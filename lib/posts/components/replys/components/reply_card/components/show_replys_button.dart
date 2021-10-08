// material
import 'package:flutter/material.dart';
// model
import 'package:whisper/posts/components/replys/replys_model.dart';

class ShowReplyButton extends StatelessWidget {

  const ShowReplyButton({
    Key? key,
    required this.replysModel
  }) : super(key: key);

  final ReplysModel replysModel;
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await replysModel.getReplyDocs(context);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}