// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'user_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_model.dart';

class UserCards extends StatelessWidget {

  const UserCards({
    Key? key,
    required this.userDocs,
    required this.mainModel,
    required this.mutesUsersModel
  }) : super(key: key);

  final List<DocumentSnapshot> userDocs;
  final MainModel mainModel;
  final MutesUsersModel mutesUsersModel;

  @override 
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: userDocs.length,
      itemBuilder: (context,i) {
        return UserCard(userDoc: userDocs[i],mainModel: mainModel,mutesUsersModel: mutesUsersModel,);
      }
    );
  }
}