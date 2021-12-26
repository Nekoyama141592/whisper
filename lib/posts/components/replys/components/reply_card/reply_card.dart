// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
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

  Widget build(BuildContext context,ScopedReader watch) {

    final postFutures = watch(postsFeaturesProvider);
    final String userImageURL = reply['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    final fontSize = 16.0;
    final whisperTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      overflow: TextOverflow.ellipsis
    );
    // 
    return isDisplayUidFromMap(mutesUids: mainModel.mutesUids, blocksUids: mainModel.blocksUids, mutesIpv6s: mainModel.mutesIpv6s, map: reply) && mainModel.mutesReplyIds.contains(reply['replyId']) ?
    
    Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(reply['uid'] == mainModel.currentUserDoc['uid']) ?
      [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await postFutures.muteUser(mutesUids: mainModel.mutesUids, currentUserDoc: mainModel.currentUserDoc, mutesIpv6AndUids: mainModel.mutesIpv6AndUids, map: reply);
          } ,
        ),

        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(blocksUids: mainModel.blocksUids,currentUserDoc: mainModel.currentUserDoc,blocksIpv6AndUids: mainModel.blocksIpv6AndUids,map: reply);
          },
        ),
      ] : [],
      child: InkWell(
        onLongPress: mainModel.currentUserDoc['isAdmin'] ? () async {
          await FlutterClipboard.copy(reply['uid']);
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
                      child: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding, passiveUserDocId: reply['userDocId'], mainModel: mainModel),
                    ),
                    Expanded(
                      child: SizedBox(
                        child: Column(
                          children: [
                            Text(
                              reply['userName'],
                              style: whisperTextStyle
                            ),
                            SizedBox(height: 10.0,),
                            Text(
                              reply['reply'],
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