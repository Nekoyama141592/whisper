// material
import 'package:flutter/material.dart';
// domain
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// model
import 'package:whisper/models/comments/comments_model.dart';

class CommentHiddenButton extends StatelessWidget {

  const CommentHiddenButton({
    Key? key,
    required this.whisperPostComment,
    required this.commentsModel,
  }) : super(key: key);

  final WhisperPostComment whisperPostComment;
  final CommentsModel commentsModel;
  @override 
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(commentsModel.isUnHiddenPostCommentIds.contains(whisperPostComment.postCommentId) ? Icons.visibility : Icons.visibility_off ),
      onTap: () => commentsModel.toggleIsHidden(whisperPostComment: whisperPostComment),
    );
  }
}