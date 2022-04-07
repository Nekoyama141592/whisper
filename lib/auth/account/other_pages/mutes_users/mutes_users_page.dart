// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/components/user_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_model.dart';

class MutesUsersPage extends ConsumerWidget {

  const MutesUsersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref) {

    final mutesUsersModel = ref.watch(mutesUsersProvider);
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ミュートしているユーザー'),
        ),
        body: mutesUsersModel.isLoading ?
        Loading()
        : JudgeScreen(
          list: mutesUsersModel.userDocs,
          reload: () async => await mutesUsersModel.onReload(),
          content: UserCards(userDocs: mutesUsersModel.userDocs, mainModel: mainModel),
        )
      ),
    );
  }
}