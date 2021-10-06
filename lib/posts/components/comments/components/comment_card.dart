// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/replys/reply_button.dart';
// models
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
class CommentCard extends StatelessWidget {

  const CommentCard({
    Key? key,
    required this.comment,
    required this.commentsModel,
    required this.replysModel,
    required this.currentUserDoc,
    required this.currentSongDoc,
    required this.likedCommentIds
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final List<dynamic> likedCommentIds;

  @override  
  Widget build(BuildContext context){
    final commentId = comment['commentId'];
    final size = MediaQuery.of(context).size;
    final replyEditingController = TextEditingController();
    final thisComment = comment;
    
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width * 0.98,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(4.0))
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0
                  ),
                  child: UserImage(userImageURL: comment['userImageURL'], length: 60.0, padding: 0.0),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  child: Column(
                    children: [
                      Text(comment['userName']),
                      SizedBox(height: 10.0,),
                      Text(comment['comment'])
                    ],
                  ),
                ),
                Row(
                  children: [
                    ReplyButton(replysModel: replysModel, currentSongDoc: currentSongDoc, replyEditingController: replyEditingController, currentUserDoc: currentUserDoc, thisComment: thisComment),
                    CommentLikeButton(commentsModel: commentsModel, currentUserDoc: currentUserDoc, currentSongDoc: currentSongDoc, likedCommentIds: likedCommentIds, commentId: commentId)
                  ],
                )
              ]
            ),
          ),
        ],
      ),
    );
  }
}