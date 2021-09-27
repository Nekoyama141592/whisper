import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:firebase_auth/firebase_auth.dart';

import 'account_model.dart';

class AccountPage extends ConsumerWidget {

  const AccountPage({
    Key? key,
    required this.currentUserDoc,
    required this.currentUser
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final User? currentUser;

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
            },
          ),
          InkWell(
            child: ListTile(
              title: Text('パスワード変更'),
            ),
            onTap: () {
              _accountModel.whichState = WhichState.updatePassword;
              routes.toReauthenticationPage(context, currentUser,_accountModel);
            },
          ),
        ],
      ),
    );
  }
}