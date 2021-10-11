// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/components/search/post_search/components/comments/search_comments_model.dart';

class CommentLikeButton extends StatelessWidget {

  const CommentLikeButton({
    Key? key,
    required this.searchCommentsModel,
    required this.currentUserDoc,
    required this.currentSongMap,
    required this.likedCommentIds,
    required this.commentId,
    required this.likedComments
  }) : super(key: key);

  final SearchCommentsModel searchCommentsModel;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> currentSongMap;
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
        searchCommentsModel.reload();
        await searchCommentsModel.like(currentUserDoc, currentSongMap, commentId,likedComments);
      }, 
      icon: Icon(Icons.favorite)
    );
  }

}