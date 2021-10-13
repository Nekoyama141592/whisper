// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_slidable/flutter_slidable.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
import 'package:whisper/main_model.dart';
// models
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class ReplyCard extends StatelessWidget {

  const ReplyCard({
    Key? key,
    required this.reply,
    required this.searchReplysModel,
    required this.mainModel
  }) : super(key: key);

  final Map<String,dynamic> reply;
  final SearchReplysModel searchReplysModel;
  final MainModel mainModel;

  Widget build(BuildContext context) {
    final String userImageURL = reply['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    return !reply['commentId'] == searchReplysModel.giveComment['commentId']  ||  mainModel.blockingUids.contains(reply['uid']) || mainModel.mutesUids.contains(reply['uid']) ?
    SizedBox.shrink()
    : Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.25,
      actions: !reply['uid'] == mainModel.currentUserDoc['uid'] ?
      [  
        IconSlideAction(
          caption: 'mute User',
          color: Colors.transparent,
          icon: Icons.person_off,
          onTap: () => print("mute User"),
        ),
        IconSlideAction(
          caption: 'mute Post',
          color: Colors.transparent,
          icon: Icons.visibility_off,
          onTap: () => print("mute reply"),
        ),
        IconSlideAction(
          caption: 'block User',
          color: Colors.transparent,
          icon: Icons.block,
          onTap: () => print("blockUser"),
        ),
      ] : [],
      child: ListTile(
        leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding, passiveUserDocId: reply['userDocId'], mainModel: mainModel),
        title: Text(reply['userName']),
        subtitle: Text(
          reply['commentId'].toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

}