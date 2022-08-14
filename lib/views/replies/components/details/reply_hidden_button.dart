// material
import 'package:flutter/material.dart';
// domain
import 'package:whisper/domain/whisper_reply/whisper_reply.dart';
// models
import 'package:whisper/models/replies/replies_model.dart';

class ReplyHiddenButton extends StatelessWidget {

  const ReplyHiddenButton({
    Key? key,
    required this.whisperReply,
    required this.repliesModel,
  }) : super(key: key);

  final WhisperReply whisperReply;
  final RepliesModel repliesModel;
  @override 
  Widget build(BuildContext context) {
    return InkWell(
      child: Icon(repliesModel.isUnHiddenPostCommentReplyIds.contains(whisperReply.postCommentReplyId) ? Icons.visibility : Icons.visibility_off ),
      onTap: () => repliesModel.toggleIsHidden(whisperReply: whisperReply)
    );
  }
}