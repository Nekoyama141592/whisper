// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/others.dart';
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
    required this.reply,
    required this.replysModel,
    required this.mainModel
  }) : super(key: key);

  final Map<String,dynamic> reply;
  final ReplysModel replysModel;
  final MainModel mainModel;

  Widget build(BuildContext context,WidgetRef ref) {

    final postFutures = ref.watch(postsFeaturesProvider);
    final whisperReply = fromMapToWhisperReply(replyMap: reply);
    final String userImageURL = whisperReply.userImageURL;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final length = 60.0;
    final padding = 0.0;
    final fontSize = 16.0;
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
    );
    return isDisplayUidFromMap(mutesUids: mainModel.mutesUids, blocksUids: mainModel.blocksUids, blocksIpv6s: mainModel.blocksIpv6s, mutesIpv6s: mainModel.mutesIpv6s, map: reply) && !mainModel.mutesReplyIds.contains(whisperReply.replyId) ?
    
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
            await postFutures.muteUser(mainModel: mainModel, map: reply);
          } ,
        ),

        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(mainModel: mainModel, map: reply);
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
                  borderRadius: BorderRadius.all(Radius.circular(4.0))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0
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
                            SizedBox(height: 10.0,),
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
                        ReplyLikeButton(thisReply: reply, mainModel: mainModel, replysModel: replysModel)
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