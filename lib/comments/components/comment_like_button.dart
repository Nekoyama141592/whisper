// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
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

    return mainModel.likePostCommentIds.contains(whisperComment.postCommentId) ?
    Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding(context: context)
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite,color: Colors.red),
            onTap: () async {
              await commentsModel.unlike(whisperComment: whisperComment, mainModel: mainModel);
            },
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          Text(
            returnJaInt(count: likeCount),
            style: TextStyle(color: Colors.red)
          )
        ],
      ),
    ) : Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding(context: context)/2.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite),
            onTap: () async {
              await commentsModel.like(whisperComment: whisperComment, mainModel: mainModel);
            },
          ),
          SizedBox(width: defaultPadding(context: context)/2.0),
          Text(
            returnJaInt(count: likeCount)
          )
        ],
      ),
    );
  }

}