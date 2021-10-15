// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/posts/components/replys/replys_model.dart';
import 'package:whisper/posts/components/post_buttons/posts_futures.dart';

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
    
    return !reply['commentId'] == replysModel.giveComment['commentId'] ||  mainModel.blockingUids.contains(reply['uid']) || mainModel.mutesUids.contains(reply['uid']) ?
    SizedBox.shrink()
    : Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !(reply['uid'] == mainModel.currentUserDoc['uid']) ?
      [
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () async {
            await postFutures.muteUser(mainModel.mutesUids, reply['uid'], mainModel.prefs);
          } ,
        ),
        IconSlideAction(
          caption: 'mute Post',
          color: Colors.transparent,
          icon: Icons.visibility_off,
          onTap: () async {
            await postFutures.muteReply(mainModel.mutesReplyIds, reply['replyId'], mainModel.prefs);
          },
        ),
        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () async {
            await postFutures.blockUser(mainModel.currentUserDoc, mainModel.blockingUids, reply['uid']);
          },
        ),
      ] : [],
      child: ListTile(
        leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding, passiveUserDocId: reply['userDocId'], mainModel: mainModel),
        title: Text(reply['userName']),
        subtitle: Text(
          reply['reply'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

}