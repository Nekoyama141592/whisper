// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/ints.dart';
// constants
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/comments/comments_model.dart';

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

    return mainModel.likePostCommentIds.contains(whisperComment.postCommentId) ?
    Row(
      children: [
        InkWell(
          child: Icon(Icons.favorite,color: Colors.red),
          onTap: () async => await commentsModel.unlike(whisperComment: whisperComment, mainModel: mainModel)
        ),
        Text(
          returnJaInt(count: plusOneCount),
          style: TextStyle(color: Colors.red)
        )
      ],
    ) : Row(
      children: [
        InkWell(
          child: Icon(Icons.favorite),
          onTap: () async => await commentsModel.like(whisperComment: whisperComment, mainModel: mainModel),
        ),
        SizedBox(width: defaultPadding(context: context)/2.0),
        Text(
          returnJaInt(count: likeCount)
        )
      ],
    );
  }

}