// material
import 'package:flutter/material.dart';

class CommentLikeButton extends StatelessWidget {

  const CommentLikeButton({
    Key? key,
    required this.likedCommentIds,
    required this.commentId
  }) : super(key: key);

  final List<dynamic> likedCommentIds;
  final String commentId;

  @override 
  Widget build(BuildContext context) {
    return likedCommentIds.contains(commentId) ?
    IconButton(
      onPressed: () {}, 
      icon: Icon(Icons.favorite,color: Colors.red,)
    )
    : IconButton(
      onPressed: (){
      }, 
      icon: Icon(Icons.favorite)
    );
  }

}