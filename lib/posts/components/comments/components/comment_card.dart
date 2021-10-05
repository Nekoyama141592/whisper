// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/colors.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/comments/components/comment_reply_button.dart';

class CommentCard extends StatelessWidget {

  const CommentCard({
    Key? key,
    required this.comment,
    required this.currentSongDoc,
    required this.likedCommentIds
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final DocumentSnapshot currentSongDoc;
  final List<dynamic> likedCommentIds;

  @override  
  Widget build(BuildContext context){
    final commentId = comment['commentId'];
    final size = MediaQuery.of(context).size;
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ListTile(
          //   leading: UserImage(
          //     userImageURL: comment['userImageURL'], 
          //     length: 60.0, 
          //     padding: 0.0
          //   ),
          //   title: Text(comment['userName']),
          //   subtitle: Text(comment['comment']),
          //   trailing: CommentLikeButton(likedCommentIds: likedCommentIds, commentId: commentId),
          // )
          Container(
            height: 60,
            width: size.width * 0.98,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
            child: Row(
              
            ),
          ),
        ],
      ),
    );
  }
}