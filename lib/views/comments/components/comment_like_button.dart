// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// domain
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/comments/comments_model.dart';

class CommentLikeButton extends StatelessWidget {

  const CommentLikeButton({
    Key? key,
    required this.commentsModel,
    required this.whisperComment,
    required this.mainModel
  }) : super(key: key);

  final CommentsModel commentsModel;
  final WhisperPostComment whisperComment;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    
    final likeCount = whisperComment.likeCount;
    final plusOneCount = likeCount + plusOne;
    final L10n l10n = returnL10n(context: context)!;
    return mainModel.likePostCommentIds.contains(whisperComment.postCommentId) ?
    Row(
      children: [
        InkWell(
          child: Icon(Icons.favorite,color: Colors.red),
          onTap: () async => await commentsModel.unlike(whisperComment: whisperComment, mainModel: mainModel)
        ),
        likeText(text: l10n.count(plusOneCount))
      ],
    ) : Row(
      children: [
        InkWell(
          child: Icon(Icons.favorite),
          onTap: () async => await commentsModel.like(whisperComment: whisperComment, mainModel: mainModel),
        ),
        SizedBox(width: defaultPadding(context: context)/2.0),
        Text(l10n.count(likeCount))
      ],
    );
  }

}