// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/replys/components/reply_card/components/show_replys_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';

class CommentCard extends StatelessWidget {

  const CommentCard({
    Key? key,
    required this.comment,
    required this.commentsModel,
    required this.replysModel,
    required this.currentSongDoc,
    required this.mainModel
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final DocumentSnapshot currentSongDoc;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context){
    final commentId = comment['commentId'];
    
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () => print("mute User"),
        ),
        IconSlideAction(
          caption: 'mute Post',
          color: Colors.transparent,
          icon: Icons.visibility_off,
          onTap: () => print("mute comment"),
        ),
        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () => print("blockUser"),
        ),
      ],
      child: Card(
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
                      child: RedirectUserImage(userImageURL: comment['userImageURL'], length: 60.0, padding: 0.0, passiveUserDocId: comment['userDocId'], mainModel: mainModel),
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
                        CommentLikeButton(commentsModel: commentsModel, currentUserDoc: mainModel.currentUserDoc, currentSongDoc: currentSongDoc, likedCommentIds: mainModel.likedCommentIds, commentId: commentId,likedComments: mainModel.likedComments),
                        if(comment['uid'] == currentSongDoc['uid'] ) ShowReplyButton(replysModel: replysModel, currentSongDoc: currentSongDoc, currentUserDoc: mainModel.currentUserDoc, thisComment: comment)
                      ],
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}