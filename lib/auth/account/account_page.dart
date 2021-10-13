// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'account_model.dart';

class AccountPage extends ConsumerWidget {

  const AccountPage({
    Key? key,
    required this.currentUserDoc,
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;

  @override 
  Widget build(BuildContext context, ScopedReader watch) {

    final accountModel = watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(accountModel.currentUser!.email!),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.updateEmail;
              routes.toReauthenticationPage(context, accountModel.currentUser, accountModel,currentUserDoc);
            },
          ),
          ListTile(
            title: Text('パスワード変更'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.updatePassword;
              routes.toReauthenticationPage(context, accountModel.currentUser,accountModel,currentUserDoc);
            },
          ),
           ListTile(
            title: Text('アカウント削除の手順をふむ'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.deleteUser;
              routes.toReauthenticationPage(context, accountModel.currentUser, accountModel,currentUserDoc);
            },
          ),
          ListTile(
            title: Text('ログアウト'),
            onTap: () {
              accountModel.showSignOutDialog(context);
            },
          ),
        ],
      ),
    );
  }
}