// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/user_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/auth/mutes_users_model.dart';

class UserCards extends StatelessWidget {

  const UserCards({
    Key? key,
    required this.userDocs,
    required this.mainModel,
    required this.muteUsersModel,
  }) : super(key: key);

  final List<DocumentSnapshot<Map<String,dynamic>>> userDocs;
  final MainModel mainModel;
  final MuteUsersModel muteUsersModel;

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding(context: context)),
      child: ListView.builder(
        itemCount: userDocs.length,
        itemBuilder: (context,i) {
          final userDoc = userDocs[i];
          return InkWell(
            child: UserCard(result: userDoc.data()!, mainModel: mainModel),
            onTap: () => muteUsersModel.unMuteUser(context: context,passiveUid: userDoc.id, mainModel: mainModel)
          );
        }
      ),
    );
  }
}