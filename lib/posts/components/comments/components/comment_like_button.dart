// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/ints.dart';
// constants
import 'package:whisper/constants/others.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';

class CommentLikeButton extends StatelessWidget {

  const CommentLikeButton({
    Key? key,
    required this.commentsModel,
    required this.comment,
    required this.mainModel
  }) : super(key: key);

  final CommentsModel commentsModel;
  final Map<String,dynamic> comment;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    
    final whisperComment = fromMapToWhisperComment(commentMap: comment);
    final commentId = whisperComment.commentId;
    final likeCount = whisperComment.likeCount;
    final plusOneCount = likeCount + plusOne;
    return mainModel.likeCommentIds.contains(commentId) ?
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite,color: Colors.red),
            onTap: () async {
              await commentsModel.unlike(thisComment: comment, mainModel: mainModel);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万' :  plusOneCount.toString(),
            style: TextStyle(color: Colors.red)
          )
        ],
      ),
    ) : Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite),
            onTap: () async {
              await commentsModel.like(thisComment: comment, mainModel: mainModel);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likeCount >= 10000 ? (likeCount/1000.floor()/10).toString() + '万' :  likeCount.toString(),
          )
        ],
      ),
    );
  }

}