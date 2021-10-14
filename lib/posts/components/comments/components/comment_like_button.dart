// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// model
import 'package:whisper/posts/components/comments/comments_model.dart';

class CommentLikeButton extends StatelessWidget {

  const CommentLikeButton({
    Key? key,
    required this.commentsModel,
    required this.currentUserDoc,
    required this.currentSongDoc,
    required this.likedCommentIds,
    required this.commentId,
    required this.likedComments
  }) : super(key: key);

  final CommentsModel commentsModel;
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final List<dynamic> likedCommentIds;
  final String commentId;
  final List<dynamic> likedComments;
  
  @override 
  Widget build(BuildContext context) {
    return likedCommentIds.contains(commentId) ?
    IconButton(
      onPressed: () {
      }, 
      icon: Icon(Icons.favorite,color: Colors.red,)
    )
    : IconButton(
      onPressed: () async {
        likedCommentIds.add(commentId);
        commentsModel.reload();
        await commentsModel.like(currentUserDoc, currentSongDoc, commentId,likedComments);
      }, 
      icon: Icon(Icons.favorite)
    );
  }

}