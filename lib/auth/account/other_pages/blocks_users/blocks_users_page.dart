// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/judge_screen.dart';
import 'package:whisper/auth/account/other_pages/blocks_users/components/user_cards.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/auth/account/other_pages/blocks_users/blocks_users_model.dart';

class BlocksUsersPage extends ConsumerWidget {

  const BlocksUsersPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref) {

    final blocksUsersModel = ref.watch(blocksUsersProvider);
    return Scaffold(
      appBar: AppBar(title: Text('ブロックしているユーザー'),),
      body: blocksUsersModel.isLoading ?
      Loading()
      : JudgeScreen(
        list: blocksUsersModel.blocksUserDocs, 
        reload: () async { 
          await blocksUsersModel.getBlocksUserDocs(blocksUids: mainModel.blocksUids);
        },
        content: UserCards(userDocs: blocksUsersModel.blocksUserDocs,mainModel: mainModel,blocksUsersModel: blocksUsersModel,)
      )
    );
  }
}