// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/blocking_users/blocking_users_model.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
    required this.userDoc,
    required this.mainModel,
    required this.blockingUsersModel
  }) : super(key: key);

  final DocumentSnapshot userDoc;
  final MainModel mainModel;
  final BlockingUsersModel blockingUsersModel;

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
              leading: UserImage(padding: 0.0, length: 50.9, userImageURL: userDoc['userImageURL']),
              title: Text(userDoc['userName'],overflow: TextOverflow.ellipsis,),
              onTap: () async {
                await blockingUsersModel.unBlockUser(userDoc['uid'], mainModel.blockingUids, mainModel.currentUserDoc,mainModel.mutesIpv6AndUids);
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