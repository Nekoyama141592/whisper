// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/comments/components/show_replys_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class CommentCard extends ConsumerWidget {

  const CommentCard({
    Key? key,
    required this.comment,
    required this.commentsModel,
    required this.replysModel,
    required this.currentSongMap,
    required this.mainModel
  }): super(key: key);
  
  final Map<String,dynamic> comment;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final Map<String,dynamic> currentSongMap;
  final MainModel mainModel;
  @override  
  Widget build(BuildContext context,ScopedReader watch) {
    
    final postFutures = watch(postsFeaturesProvider);
    final fontSize = 16.0;
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      overflow: TextOverflow.ellipsis
    );

    return mainModel.blockingUids.contains(comment['uid']) || mainModel.mutesUids.contains(comment['uid']) ?
    SizedBox.shrink()
    : Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(comment['uid'] == mainModel.currentUserDoc['uid']) ?
      [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await postFutures.muteUser(mainModel.currentUserDoc,mainModel.mutesUids, comment['uid']);
          } ,
        ),
        IconSlideAction(
          caption: 'mute Post',
          color: Colors.transparent,
          icon: Icons.visibility_off,
          onTap: () async {
            await postFutures.muteComment(mainModel.mutesCommentIds, comment['commentId'], mainModel.prefs);
          },
        ),
        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, comment['uid']);
          },
        ),
      ]: [],
      child: Card(
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
                    child: Column(
                      children: [
                        Text(
                          comment['userName'],
                          style: whisperTextStyle,
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          comment['comment'],
                          style: whisperTextStyle,
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CommentLikeButton(commentsModel: commentsModel, currentUserDoc: mainModel.currentUserDoc, currentSongMap: currentSongMap, likedCommentIds: mainModel.likedCommentIds, comment: comment, likedComments: mainModel.likedComments),
                      if(comment['uid'] == currentSongMap['uid'] ) ShowReplyButton(replysModel: replysModel, currentSongMap: currentSongMap, currentUserDoc: mainModel.currentUserDoc, thisComment: comment)
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