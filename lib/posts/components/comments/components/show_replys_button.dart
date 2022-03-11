// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class ShowReplyButton extends ConsumerWidget {

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

  Widget build(BuildContext context,WidgetRef ref ) {
    final CommentsOrReplysModel commentsOrReplysModel = ref.watch(commentsOrReplysProvider);
    return IconButton(
      onPressed: () async {
        toReplysPage(context: context, replysModel: replysModel, whisperPost: whisperPost, whisperPostComment: whisperPostComment, mainModel: mainModel, commentsOrReplysModel: commentsOrReplysModel);
        await replysModel.init(context: context, mainModel: mainModel, whisperPostComment: whisperPostComment);
      }, 
      icon: Icon(Icons.mode_comment)
    );
  }
}