// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/replys/components/reply_card/components/show_replys_button.dart';
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
    required this.likedCommentIds,
    required this.likedComments
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot currentSongDoc;
  final List<dynamic> likedCommentIds;
  final List<dynamic> likedComments;
  @override  
  Widget build(BuildContext context){
    final commentId = comment['commentId'];
    
    return Card(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
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
                  Expanded(
                    child: SizedBox(
                      child: Column(
                        children: [
                          Text(comment['userName']),
                          SizedBox(height: 10.0,),
                          Text(comment['comment'])
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // AddReplyButton(replysModel: replysModel, currentSongDoc: currentSongDoc, replyEditingController: replyEditingController, currentUserDoc: currentUserDoc, thisComment: thisComment),
                      CommentLikeButton(commentsModel: commentsModel, currentUserDoc: currentUserDoc, currentSongDoc: currentSongDoc, likedCommentIds: likedCommentIds, commentId: commentId,likedComments: likedComments),
                      if(comment['uid'] == currentSongDoc['uid'] ) ShowReplyButton(replysModel: replysModel, currentSongDoc: currentSongDoc, currentUserDoc: currentUserDoc, thisComment: comment)
                    ],
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}