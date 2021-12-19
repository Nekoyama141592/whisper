// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/auth/account/other_pages/blocking_users/components/user_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/blocking_users/blocking_users_model.dart';

class BlockingUsersPage extends ConsumerWidget {

  const BlockingUsersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final blockingUsersModel = watch(blockingUsersProvider);
    return Scaffold(
      appBar: AppBar(title: Text('BlockingUser'),),
      body: blockingUsersModel.isLoading ?
      Loading()
      : JudgeScreen(
        list: blockingUsersModel.blockingUserDocs, 
        reload: () async { mainModel.setCurrentUser(); },
        content: UserCards(userDocs: blockingUsersModel.blockingUserDocs,mainModel: mainModel,blockingUsersModel: blockingUsersModel,)
      )
    );
  }
}