// material
import 'package:flutter/material.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
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
    required this.whisperComment,
    required this.whisperPost
  }) : super(key: key);

  final MainModel mainModel;
  final ReplysModel replysModel;
  final WhisperComment whisperComment;
  final Post whisperPost;

  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        replysModel.getReplysStream(context: context, whisperComment: whisperComment, replysModel: replysModel, whisperPost: whisperPost, mainModel: mainModel);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}