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
    required this.comment,
    required this.likedComments
  }) : super(key: key);

  final CommentsModel commentsModel;
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final List<dynamic> likedCommentIds;
  final Map<String,dynamic> comment;
  final List<dynamic> likedComments;
  
  @override 
  Widget build(BuildContext context) {
    
    final commentId = comment['commentId'];
    List<dynamic> likesUids = comment['likesUids'];
    final likesCount = likesUids.length;
    final plusOneCount = likesUids.length + 1;
    
    return likedCommentIds.contains(commentId) ?
    IconButton(
      onPressed: () {
      }, 
      icon: Icon(Icons.favorite,color: Colors.red,)
    )
    : IconButton(
      onPressed: () async {
        await commentsModel.like(likedCommentIds,currentUserDoc, currentSongDoc, commentId,likedComments);
      }, 
      icon: Icon(Icons.favorite)
    );
  }

}