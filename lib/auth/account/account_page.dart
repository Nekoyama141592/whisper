// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
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
  Widget build(BuildContext context, ScopedReader watch) {

    final accountModel = watch(accountProvider);
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
              showCupertinoDialog(context: context, builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('注意'),
                  content: Text('ミュートしているユーザーが表示されます。'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Ok'),
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        routes.toMutesUsersPage(context, mainModel);
                      },
                    )
                  ],
                );
              });
            },
          ),
          ListTile(
            title: Text('ブロックしているユーザー'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              showCupertinoDialog(context: context, builder: (context) {
                return CupertinoAlertDialog(
                  title: Text('注意'),
                  content: Text('ブロックしているユーザーが表示されます。'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Ok'),
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                        routes.toBlockingUsersPage(context, mainModel);
                      },
                    )
                  ],
                );
              });
            },
          ),
          ListTile(
            title: Text('固有のユーザー名'),
            subtitle: Text(
              mainModel.currentUserDoc['uid'],
              style: TextStyle(color: Theme.of(context).focusColor),
            ),
            trailing: InkWell(
              child: Icon(Icons.copy),
              onTap: () async {
                await FlutterClipboard.copy(mainModel.currentUserDoc['uid']).then((_) {
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