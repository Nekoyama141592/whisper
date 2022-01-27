// material
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// model
import 'account_model.dart';
import 'package:whisper/main_model.dart';

class AccountPage extends ConsumerWidget {

  const AccountPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, WidgetRef ref) {

    final accountModel = ref.watch(accountProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(accountModel.currentUser!.email! + "(変更する)"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.updateEmail;
              routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
            },
          ),
          ListTile(
            title: Text('パスワード変更'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.updatePassword;
              routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
            },
          ),
           ListTile(
            title: Text('アカウント削除の手順をふむ'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              accountModel.whichState = WhichState.deleteUser;
              routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
            },
          ),
          ListTile(
            title: Text('ミュートしているユーザー'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              voids.showCupertinoDialogue(context: context, title: '注意', content: 'ミュートしているユーザーが表示されます', action: () async {
                Navigator.pop(context);
                await Future.delayed(Duration(milliseconds: dialogueMilliSeconds));
                routes.toMutesUsersPage(context, mainModel);
              });
            },
          ),
          ListTile(
            title: Text('ブロックしているユーザー'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              voids.showCupertinoDialogue(context: context, title: '注意', content: 'ブロックしているユーザーが表示されます', action: () {
                Navigator.pop(context);
                routes.toBlocksUsersPage(context, mainModel);
              });
            },
          ),
          ListTile(
            title: Text('固有のユーザー名'),
            subtitle: Text(
              mainModel.currentWhisperUser.uid,
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            trailing: InkWell(
              child: Icon(Icons.copy),
              onTap: () async {
                await FlutterClipboard.copy(mainModel.currentWhisperUser.uid).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('固有のユーザー名をコピーしました')));
                });
              },
            ),
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