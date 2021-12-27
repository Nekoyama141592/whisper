// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/blocks_users/blocks_users_model.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
    required this.userDoc,
    required this.mainModel,
    required this.blocksUsersModel
  }) : super(key: key);

  final DocumentSnapshot userDoc;
  final MainModel mainModel;
  final BlocksUsersModel blocksUsersModel;

  @override 
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).focusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 5)
          )
        ]
      ),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: RedirectUserImage(userImageURL: userDoc['imageURL'], length: 50.0, padding: 0.0, passiveUserDocId: userDoc['uid'], mainModel: mainModel),
              title: Text(userDoc['userName'],overflow: TextOverflow.ellipsis,),
              onTap: () async {
                voids.showCupertinoDialogue(context: context, title: 'ブロック解除', content: 'このユーザーのブロックを解除しますか？', action: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: dialogueMilliSeconds));
                  await blocksUsersModel.unBlockUser(passiveUid: userDoc['uid'], blocksUids: mainModel.blocksUids, currentUserDoc: mainModel.currentUserDoc, blocksIpv6AndUids: mainModel.blocksIpv6AndUids);
                });
              },
              subtitle: Text(
                userDoc['description'],
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}