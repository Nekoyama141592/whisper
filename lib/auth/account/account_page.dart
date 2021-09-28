import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/routes.dart' as routes;

import 'account_model.dart';

class AccountPage extends ConsumerWidget {

  const AccountPage({
    Key? key,
    required this.currentUserDoc,
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final _accountModel = watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: [
          InkWell(
            child: ListTile(
              title: Text(_accountModel.currentUser!.email!),
            ),
            onTap: () {
              _accountModel.whichState = WhichState.updateEmail;
              routes.toReauthenticationPage(context, _accountModel.currentUser, _accountModel);
            },
          ),
          InkWell(
            child: ListTile(
              title: Text('パスワード変更'),
            ),
            onTap: () {
              _accountModel.whichState = WhichState.updatePassword;
              routes.toReauthenticationPage(context, _accountModel.currentUser,_accountModel);
            },
          ),
          InkWell(
            child: ListTile(
              title: Text('ログアウト'),
            ),
            onTap: () {
              _accountModel.showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}