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
    required this.comment,
    required this.likedComments
  }) : super(key: key);

  final SearchCommentsModel searchCommentsModel;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> currentSongMap;
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
    
    Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0
      ),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.favorite,color: Colors.red),
            onTap: () async {
              await searchCommentsModel.unlike(likedCommentIds, currentUserDoc, currentSongMap, commentId, likedComments);
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
              await searchCommentsModel.like(likedCommentIds, currentUserDoc, currentSongMap, commentId, likedComments);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likesCount >= 10000 ? (likesCount/1000.floor()/10).toString() + '万' :  likesCount.toString(),
          )
        ],
      ),
    );
  }

}