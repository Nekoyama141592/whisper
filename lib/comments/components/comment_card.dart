// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/comments/components/report_comment_button.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/comments/components/show_replys_button.dart';
import 'package:whisper/comments/components/comment_like_button.dart';
import 'package:whisper/comments/components/comment_hidden_button.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/replies/replys_model.dart';
import 'package:whisper/comments/comments_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class CommentCard extends ConsumerWidget {

  const CommentCard({
    Key? key,
    required this.i,
    required this.whisperPostComment,
    required this.commentDoc,
    required this.whisperPost,
    required this.commentsModel,
    required this.replysModel,
    required this.mainModel,
    required this.commentsOrReplysModel
  }): super(key: key);
  
  final int i;
  final WhisperPostComment whisperPostComment;
  final DocumentSnapshot<Map<String,dynamic>> commentDoc;
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
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperPostComment.uid, ) && !mainModel.mutePostCommentIds.contains(whisperPostComment.postCommentId) ?

    Padding(
      padding: EdgeInsets.only(
        bottom: defaultPadding(context: context)/2.0
      ),
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
              child: RedirectUserImage(userImageURL: whisperPostComment.userImageURL, length: defaultPadding(context: context) * 3.8, padding: 0.0, passiveUid: whisperPostComment.uid, mainModel: mainModel),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    mainModel.currentWhisperUser.uid == whisperPostComment.uid ?
                    mainModel.currentWhisperUser.userName : 
                    whisperPostComment.userName,
                    style: whisperTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: defaultPadding(context: context),),
                  Text(
                    whisperPostComment.comment,
                    style: commentsModel.isUnHiddenPostCommentIds.contains(whisperPostComment.postCommentId) ? whisperTextStyle : hiddenStyle
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CommentLikeButton(commentsModel: commentsModel, whisperComment: whisperPostComment, mainModel: mainModel),
                ShowReplyButton(mainModel: mainModel, replysModel: replysModel,whisperPostComment: whisperPostComment, whisperPost: whisperPost),
                CommentHiddenButton(whisperPostComment: whisperPostComment, commentsModel: commentsModel),
                ReportCommentButton(
                  builder: (innerContext) {
                    return CupertinoActionSheet(
                      actions: whisperPostComment.uid == mainModel.userMeta.uid ?
                        [
                          CupertinoActionSheetAction(onPressed: () async {
                            Navigator.pop(innerContext);
                            await commentsModel.deleteMyComment(context: context, commentDoc: commentDoc, mainModel: mainModel);
                          }, child: PositiveText(text: deleteCommentJaText )),
                          CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText) ),
                        ]
                      : [
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await commentsOrReplysModel.muteUser(context: context,mainModel: mainModel,passiveUid: whisperPostComment.uid, );
                        }, child: PositiveText(text: muteUserJaText) ),
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await commentsModel.muteComment(context: context,mainModel: mainModel,whisperComment: whisperPostComment,commentDoc: commentDoc );
                        }, child: PositiveText(text: muteCommentJaText) ),
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          commentsModel.reportComment(context: context, mainModel: mainModel, whisperComment: whisperPostComment, commentDoc: commentDoc);
                        }, child: PositiveText(text: reportCommentJaText) ),
                        CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText) ),
                      ],
                    );
                  },
                  commentsOrReplysModel: commentsOrReplysModel
                )
              ],
            )
          ]
        ),
      ),
    ) : SizedBox.shrink();
  }
}