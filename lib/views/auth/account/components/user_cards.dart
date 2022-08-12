// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/details/refresh_screen.dart';
// components
import 'package:whisper/details/user_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/auth/mutes_users_model.dart';

class UserCards extends StatelessWidget {

  const UserCards({
    Key? key,
    required this.refreshController,
    required this.onRefresh,
    required this.onReload,
    required this.onLoading,
    required this.userDocs,
    required this.mainModel,
    required this.muteUsersModel,
  }) : super(key: key);

   // refresh
  final RefreshController refreshController;
  final void Function()? onRefresh;
  final void Function()? onReload;
  final void Function()? onLoading;
  final List<DocumentSnapshot<Map<String,dynamic>>> userDocs;
  final MainModel mainModel;
  final MuteUsersModel muteUsersModel;

  @override 
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding(context: context)),
      child: RefreshScreen(
        onReload: onReload,
        onRefresh: onRefresh, 
        onLoading: onLoading, 
        isEmpty: userDocs.isEmpty,
        controller: refreshController, 
        subWidget: SizedBox.shrink(),
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
      )
    );
  }
}