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
import 'package:whisper/details/slide_icon.dart';
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/comments/components/comment_like_button.dart';
import 'package:whisper/comments/components/show_replys_button.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/comments/comments_model.dart';
import 'package:whisper/replies/replys_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class CommentCard extends ConsumerWidget {

  const CommentCard({
    Key? key,
    required this.i,
    required this.whisperComment,
    required this.whisperPost,
    required this.commentsModel,
    required this.replysModel,
    required this.mainModel,
    required this.commentsOrReplysModel
  }): super(key: key);
  
  final int i;
  final WhisperPostComment whisperComment;
  final Post whisperPost;
  final CommentsModel commentsModel;
  final RepliesModel replysModel;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  @override  
  Widget build(BuildContext context,WidgetRef ref) {
    
    final fontSize = defaultHeaderTextSize(context: context);
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize/cardTextDiv2,
    );
    final hiddenStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize/cardTextDiv2,
      overflow: TextOverflow.ellipsis
    );
    final deleteSlideIcon = SlideIcon(caption: 'Delete', iconData: Icons.delete, onTap: () async { await commentsModel.deleteMyComment(context: context, i: i, mainModel: mainModel); });
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperComment.uid, ) && !mainModel.mutePostCommentIds.contains(whisperComment.postCommentId) ?

    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(whisperComment.uid == mainModel.currentWhisperUser.uid) ?
      [
        SlideIcon(caption: 'Mute User', iconData: Icons.person_off, onTap: () async {
          await commentsOrReplysModel.muteUser(context: context,mainModel: mainModel,passiveUid: whisperComment.uid, );
        } , ),
        SlideIcon(caption: 'Mute Comment',iconData: Icons.visibility_off, onTap: () async {
          await commentsOrReplysModel.muteComment(context: context,mainModel: mainModel,whisperComment: whisperComment);
        } , ),
      ]: [
        deleteSlideIcon
      ],
      child: Padding(
        padding: EdgeInsets.only(
          bottom: defaultPadding(context: context)/2.0
        ),
        child: InkWell(
          onLongPress:  () async {
            await FlutterClipboard.copy(whisperComment.uid);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ユーザーのIDをコピーしました')));
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).highlightColor.withOpacity(cardOpacity),
              ),
              borderRadius: BorderRadius.all(Radius.circular( defaultPadding(context: context) ))
            ),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding(context: context)
                  ),
                  child: RedirectUserImage(userImageURL: whisperComment.userImageURL, length: defaultPadding(context: context) * 3.8, padding: 0.0, passiveUid: whisperComment.uid, mainModel: mainModel),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        mainModel.currentWhisperUser.uid == whisperComment.uid ?
                        mainModel.currentWhisperUser.userName : 
                        whisperComment.userName,
                        style: whisperTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: defaultPadding(context: context),),
                      Text(
                        whisperComment.comment,
                        style: commentsModel.isUnHiddenPostCommentIds.contains(whisperComment.postCommentId) ? whisperTextStyle : hiddenStyle
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CommentLikeButton(commentsModel: commentsModel, whisperComment: whisperComment, mainModel: mainModel),
                    ShowReplyButton(mainModel: mainModel, replysModel: replysModel,whisperPostComment: whisperComment, whisperPost: whisperPost),
                    InkWell(
                      child: Icon(commentsModel.isUnHiddenPostCommentIds.contains(whisperComment.postCommentId) ? Icons.visibility : Icons.visibility_off ),
                      onTap: () { commentsModel.toggleIsHidden(whisperPostComment: whisperComment); },
                    )
                  ],
                )
              ]
            ),
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }
}