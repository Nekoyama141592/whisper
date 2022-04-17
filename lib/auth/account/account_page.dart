// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/auth/account/other_pages/mutes_users/mutes_users_model.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/links/user_links/user_links_model.dart';
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
    final L10n l10n = returnL10n(context: context)!;
    final UserLinksModel userLinksModel = ref.watch(userLinksProvider);
    final MuteUsersModel muteUsersModel  = ref.watch(muteUsersProvider);

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: whiteBoldText(text: l10n.account)
        ),
        body: Column(
          children: [
            ListTile(
              title: boldText(text: accountModel.currentUser!.email!),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                accountModel.whichState = WhichState.updateEmail;
                routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
              },
            ),
            ListTile(
              title: boldText(text: l10n.resetPassword),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                accountModel.whichState = WhichState.updatePassword;
                routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
              },
            ),
             ListTile(
              title: boldText(text: l10n.deleteUserProcess),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                accountModel.whichState = WhichState.deleteUser;
                routes.toReauthenticationPage(context: context, currentUser: accountModel.currentUser, accountModel: accountModel, mainModel: mainModel);
              },
            ),
            ListTile(
              title: boldText(text: l10n.muteUsers),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                final String title = l10n.alert;
                final String content = l10n.muteUsersAlert;
                final builder = (innerContext) {
                  return CupertinoAlertDialog(
                    title: Text(title),
                    content: Text(content),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text(cancelText),
                        onPressed: () => Navigator.pop(innerContext)
                      ),
                      CupertinoDialogAction(
                        child: Text(okText),
                        isDestructiveAction: true,
                        onPressed: () async {
                          Navigator.pop(innerContext);
                          await Future.delayed(Duration(milliseconds: dialogueMilliSeconds));
                          routes.toMutesUsersPage(context, mainModel);
                          await muteUsersModel.init(mainModel: mainModel);
                        }
                      )
                    ],
                  );
                };
                voids.showCupertinoDialogue(context: context, builder: builder );
              },
            ),
            ListTile(
              title: boldText(text: l10n.editUserLinks),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () => userLinksModel.initLinks(context: context, currentWhisperUser: mainModel.currentWhisperUser )
            ),
            ListTile(
              title: boldText(text: l10n.uid),
              subtitle: Text(
                mainModel.currentWhisperUser.uid,
                style: TextStyle(color: Theme.of(context).focusColor),
              ),
              trailing: InkWell(
                child: Icon(Icons.copy),
                onTap: () async => await FlutterClipboard.copy(mainModel.currentWhisperUser.uid).then((_) => voids.showBasicFlutterToast(context: context, msg: '固有のユーザー名をコピーしました'))
              ),
            ),
            ListTile(
              title: boldText(text: l10n.logout),
              onTap: () => accountModel.showSignOutDialog(context: context)
            ),
          ],
        ),
      ),
    );
  }
}