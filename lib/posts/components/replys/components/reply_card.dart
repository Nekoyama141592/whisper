// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
// components
import 'package:whisper/details/slide_icon.dart';
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/posts/components/replys/components/details/reply_like_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/comments_or_replys/comments_or_replys_model.dart';

class ReplyCard extends ConsumerWidget {

  const ReplyCard({
    Key? key,
    required this.whisperReply,
    required this.repliesModel,
    required this.mainModel,
    required this.commentsOrReplysModel
  }) : super(key: key);

  final WhisperReply whisperReply;
  final RepliesModel repliesModel;
  final MainModel mainModel;
  final CommentsOrReplysModel commentsOrReplysModel;

  Widget build(BuildContext context,WidgetRef ref) {
    final String userImageURL = whisperReply.userImageURL;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final length = defaultPadding(context: context) * 4.0;
    final padding = 0.0;
    final fontSize = defaultHeaderTextSize(context: context);
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize/cardTextDiv2,
    );
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperReply.uid ) && !mainModel.mutePostCommentReplyIds.contains(whisperReply.postCommentReplyId) ?
    
    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(whisperReply.uid == currentWhisperUser.uid) ?
      [
        SlideIcon(caption: 'Mute User', iconData: Icons.person_off, onTap: () async {
          await commentsOrReplysModel.muteUser(context: context,mainModel: mainModel,passiveUid: whisperReply.uid,);
        } , ),
        SlideIcon(caption: 'Mute Reply',iconData: Icons.visibility_off, onTap: () async {
          await commentsOrReplysModel.muteReply(context: context,mainModel: mainModel,whisperReply: whisperReply);
        } , ),
      ] : [],
      child: InkWell(
        onLongPress: () async {
          await FlutterClipboard.copy(whisperReply.uid);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
        } ,
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
                child: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding, passiveUserDocId: whisperReply.uid, mainModel: mainModel),
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    children: [
                      Text(
                        whisperReply.userName,
                        style: whisperTextStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: defaultPadding(context: context),),
                      Text(
                        whisperReply.reply,
                        style: whisperTextStyle
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ReplyLikeButton(whisperReply: whisperReply, mainModel: mainModel, replysModel: repliesModel)
                ],
              )
            ]
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }
}