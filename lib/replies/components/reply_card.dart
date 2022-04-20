// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/doubles.dart';
// domain
import 'package:whisper/domain/reply/whipser_reply.dart';
// components
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/replies/components/details/reply_like_button.dart';
import 'package:whisper/replies/components/details/reply_hidden_button.dart';
import 'package:whisper/replies/components/details/report_reply_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/replies/replys_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class ReplyCard extends ConsumerWidget {

  const ReplyCard({
    Key? key,
    required this.i,
    required this.whisperReply,
    required this.replyDoc,
    required this.repliesModel,
    required this.mainModel,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final int i;
  final WhisperReply whisperReply;
  final DocumentSnapshot<Map<String,dynamic>> replyDoc;
  final RepliesModel repliesModel;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  Widget build(BuildContext context,WidgetRef ref) {
    final String userImageURL = whisperReply.userImageURL;
    final length = defaultPadding(context: context) * 4.0;
    final padding = 0.0;
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
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperReply.uid ) && !mainModel.mutePostCommentReplyIds.contains(whisperReply.postCommentReplyId) ?
    
    Padding(
      padding: EdgeInsets.only(
        bottom: defaultPadding(context: context)/2.0
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary.withOpacity(cardOpacity),
          ),
          borderRadius: BorderRadius.all(Radius.circular(defaultPadding(context: context)/4.0))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: defaultPadding(context: context)
              ),
              child: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding, passiveUid: whisperReply.uid, mainModel: mainModel),
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  children: [
                    Text(
                      mainModel.currentWhisperUser.uid == whisperReply.uid ?
                      mainModel.currentWhisperUser.userName 
                      : whisperReply.userName,
                      style: whisperTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: defaultPadding(context: context),),
                    Text(
                      whisperReply.reply,
                      style: repliesModel.isUnHiddenPostCommentReplyIds.contains(whisperReply.postCommentReplyId) ? whisperTextStyle : hiddenStyle
                    )
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ReplyLikeButton(whisperReply: whisperReply, mainModel: mainModel, replysModel: repliesModel),
                ReplyHiddenButton(whisperReply: whisperReply, repliesModel: repliesModel),
                ReportReplyButton(
                  builder: (innerContext) {
                    return CupertinoActionSheet(
                      actions: whisperReply.uid == mainModel.userMeta.uid ?
                      [
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await repliesModel.deleteMyReply(context: context, replyDoc: replyDoc, mainModel: mainModel) ;
                        }, child: PositiveText(text: deleteReplyText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
                      ]
                      : [
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await commentsOrReplysModel.muteUser(context: context, mainModel: mainModel, passiveUid: whisperReply.uid,docs: repliesModel.postCommentReplyDocs );
                        }, child: PositiveText(text: muteUserText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () async {
                          Navigator.pop(innerContext);
                          await repliesModel.muteReply(context: context, mainModel: mainModel, whisperReply: whisperReply,replyDoc: replyDoc );
                        }, child: PositiveText(text: muteReplyText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () {
                          Navigator.pop(innerContext);
                          repliesModel.reportReply(context: context, mainModel: mainModel, whisperReply: whisperReply, replyDoc: replyDoc);
                        }, child: PositiveText(text: reportReplyText(context: context)) ),
                        CupertinoActionSheetAction(onPressed: () => Navigator.pop(innerContext), child: PositiveText(text: cancelText(context: context)) ),
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