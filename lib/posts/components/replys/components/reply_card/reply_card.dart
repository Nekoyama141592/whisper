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
import 'package:whisper/posts/components/replys/components/reply_card/components/reply_like_button.dart';
import 'package:whisper/details/redirect_user_image.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/post_buttons/post_futures.dart';

class ReplyCard extends ConsumerWidget {

  const ReplyCard({
    Key? key,
    required this.whisperReply,
    required this.replysModel,
    required this.mainModel
  }) : super(key: key);

  final WhisperReply whisperReply;
  final ReplysModel replysModel;
  final MainModel mainModel;

  Widget build(BuildContext context,WidgetRef ref) {

    final postFutures = ref.watch(postsFeaturesProvider);
    final String userImageURL = whisperReply.userImageURL;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final length = defaultPadding(context: context) * 4.0;
    final padding = 0.0;
    final fontSize = defaultPadding(context: context);
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: whisperReply.uid ) && !mainModel.mutePostCommentReplyIds.contains(whisperReply.postCommentReplyId) ?
    
    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(whisperReply.uid == currentWhisperUser.uid) ?
      [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await postFutures.muteUser(mainModel: mainModel,passiveUid: whisperReply.uid,);
          } ,
        ),

        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(mainModel: mainModel,passiveUid: whisperReply.uid,);
          },
        ),
      ] : [],
      child: InkWell(
        onLongPress: mainModel.userMeta.isAdmin ? () async {
          await FlutterClipboard.copy(whisperReply.uid);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uidをコピーしました')));
        } : null,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
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
                              style: whisperTextStyle
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
                        ReplyLikeButton(whisperReply: whisperReply, mainModel: mainModel, replysModel: replysModel)
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