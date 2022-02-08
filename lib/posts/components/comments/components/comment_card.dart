// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/posts/components/comments/components/comment_like_button.dart';
import 'package:whisper/posts/components/comments/components/show_replys_button.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/comments/comments_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class CommentCard extends ConsumerWidget {

  const CommentCard({
    Key? key,
    required this.whisperComment,
    required this.whisperPost,
    required this.commentsModel,
    required this.replysModel,
    required this.mainModel,
    required this.commentsOrReplysModel
  }): super(key: key);
  
  final WhisperPostComment whisperComment;
  final Post whisperPost;
  final CommentsModel commentsModel;
  final ReplysModel replysModel;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  @override  
  Widget build(BuildContext context,WidgetRef ref) {
    
    final fontSize = defaultHeaderTextSize(context: context);
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      // overflow: TextOverflow.ellipsis
    );
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperComment.uid, ) && !mainModel.mutePostCommentIds.contains(whisperComment.postCommentId) ?

    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(whisperComment.uid == mainModel.currentWhisperUser.uid) ?
      [
        IconSlideAction(
          caption: 'Mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await commentsOrReplysModel.muteUser(mainModel: mainModel,passiveUid: whisperComment.uid, );
          } ,
        ),
        IconSlideAction(
          caption: 'Mute Comment',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await commentsOrReplysModel.muteComment(mainModel: mainModel,whisperComment: whisperComment);
          } ,
        ),

        IconSlideAction(
          caption: 'Block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await commentsOrReplysModel.blockUser(mainModel: mainModel,passiveUid: whisperComment.uid, );
          },
        ),
      ]: [],
      child: InkWell(
        onLongPress: mainModel.userMeta.isAdmin? () async {
          await FlutterClipboard.copy(whisperComment.uid);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
        } : null,
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
                      child: RedirectUserImage(userImageURL: whisperComment.userImageURL, length: 60.0, padding: 0.0, passiveUserDocId: whisperComment.uid, mainModel: mainModel),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            whisperComment.userName,
                            style: whisperTextStyle,
                          ),
                          SizedBox(height: 10.0,),
                          Text(
                            whisperComment.comment,
                            style: whisperTextStyle,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CommentLikeButton(commentsModel: commentsModel, whisperComment: whisperComment, mainModel: mainModel),
                        ShowReplyButton(mainModel: mainModel, replysModel: replysModel,whisperPostComment: whisperComment, whisperPost: whisperPost)
                      ],
                    )
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }
}