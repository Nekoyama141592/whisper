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
    required this.currentSongMap,
    required this.likedCommentIds,
    required this.comment,
    required this.likedComments
  }) : super(key: key);

  final CommentsModel commentsModel;
  final DocumentSnapshot currentUserDoc;
  final Map<String,dynamic> currentSongMap;
  final List<dynamic> likedCommentIds;
  final Map<String,dynamic> comment;
  final List<dynamic> likedComments;
  
  @override 
  Widget build(BuildContext context) {
    
    final commentId = comment['commentId'];
    List<dynamic> likesUids = comment['likesUids'];
    final likesUidsCount = likesUids.length;
    likesUids.remove(currentUserDoc['uid']); 
    final plusOneCount = likesUidsCount + 1;
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
              await commentsModel.unlike(likedCommentIds, comment, currentUserDoc, likedComments);
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
              await commentsModel.like(likedCommentIds, currentUserDoc, comment, likedComments);
            },
          ),
          SizedBox(width: 5.0),
          Text(
            likesUidsCount >= 10000 ? (likesUidsCount/1000.floor()/10).toString() + '万' :  likesUidsCount.toString(),
          )
        ],
      ),
    );
  }

}