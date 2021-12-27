// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_model.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
    required this.userDoc,
    
    required this.mainModel,
    required this.mutesUsersModel
  }) : super(key: key);

  final DocumentSnapshot userDoc;
  final MainModel mainModel;
  final MutesUsersModel mutesUsersModel;

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
              leading: UserImage(padding: 0.0, length: 50.9, userImageURL: userDoc['imageURL']),
              title: Text(userDoc['userName'],overflow: TextOverflow.ellipsis,),
              onTap: () {
                voids.showCupertinoDialogue(context: context, title: 'ミュート解除', content: 'このユーザーのミュートを解除しますか？', action: () async {
                  Navigator.pop(context);
                  await Future.delayed(Duration(milliseconds: dialogueMilliSeconds));
                  await await mutesUsersModel.unMuteUser(passiveUid: userDoc['uid'], mutesUids: mainModel.mutesUids, currentUserDoc: mainModel.currentUserDoc, mutesIpv6AndUids: mainModel.mutesIpv6AndUids);
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