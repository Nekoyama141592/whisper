// material
import 'package:flutter/material.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ShowReplyButton extends StatelessWidget {

  const ShowReplyButton({
    Key? key,
    required this.mainModel,
    required this.replysModel,
    required this.whisperPostComment,
    required this.whisperPost
  }) : super(key: key);

  final MainModel mainModel;
  final RepliesModel replysModel;
  final WhisperPostComment whisperPostComment;
  final Post whisperPost;

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        await replysModel.init(context: context, mainModel: mainModel, whisperPostComment: whisperPostComment);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}