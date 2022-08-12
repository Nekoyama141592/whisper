// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/l10n/l10n.dart';
// models
import 'package:whisper/main_model.dart';

final accountProvider = ChangeNotifierProvider(
  (ref) => AccountModel()
);

enum WhichState {
  initialValue,
  updateEmail,
  updatePassword,
  deleteUser     
}

class AccountModel extends ChangeNotifier {
  
  User? currentUser= FirebaseAuth.instance.currentUser;

  WhichState whichState = WhichState.initialValue;
  String password = '';
  
  Future <void>reauthenticateWithCredential ({required BuildContext context,required User? currentUser,required MainModel mainModel})  async {
    
    currentUser = FirebaseAuth.instance.currentUser;
    final String email = currentUser!.email!;
    final credential = EmailAuthProvider.credential(email: email, password: password);

    try {
      await currentUser.reauthenticateWithCredential(credential);
      switch(whichState) {
        case WhichState.initialValue:
        break;
        case WhichState.updatePassword:
          routes.toUpdatePassword(context: context, currentUser: currentUser );
        break;
        case WhichState.updateEmail:
          routes.toUpdateEmailPage(context, currentUser);
        break;
        case WhichState.deleteUser:
          showDeleteUserDialog(context: context, mainModel: mainModel);
        break;
      }
    } on FirebaseAuthException catch(e) {
      final L10n l10n = returnL10n(context: context)!;
      switch(e.code) {
        case 'invalid-email':
        voids.showBasicFlutterToast(context: context, msg: l10n.invalidEmail );
        break;
        case 'wrong-password':
        voids.showBasicFlutterToast(context: context, msg: l10n.wrongPassword);
        break;
      }
    }
  }

  void showDeleteUserDialog({ required BuildContext context, required MainModel mainModel }) {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final L10n l10n = returnL10n(context: context)!;
    final String title = l10n.deleteUser;
    final String content = l10n.deleteUserAlert;
    voids.showCupertinoDialogue(
      context: context,
      builder: (innerContext) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text(cancelText(context: context)),
              onPressed: () => Navigator.pop(innerContext)
            ),
            CupertinoDialogAction(
              child: Text(okText),
              isDestructiveAction: true,
              onPressed: () async {
                if (currentUser!.uid == mainModel.currentWhisperUser.uid) {
                  Navigator.pop(innerContext);
                  routes.toIsFinishedPage(context: context,title: l10n.deletedUser,text: l10n.deletedUserText);
                  await deleteUserFromFireStoreAndFirebaseAuth(context: context, currentWhisperUser: currentWhisperUser);
                }
              },
            ),
          ],
        );
      }
    );
  }

  Future<void> deleteUserFromFireStoreAndFirebaseAuth({ required BuildContext context, required WhisperUser currentWhisperUser}) async {
    await returnUserMetaDocRef(uid: currentWhisperUser.uid).delete().then((_) async {
      await currentUser!.delete();  
    });
  }

  void showSignOutDialog({ required BuildContext context }) {
    final L10n l10n = returnL10n(context: context)!;
    final String title = l10n.logout;
    final String content = l10n.logoutAlert;
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: Text(cancelText(context: context)),
            onPressed: () => Navigator.pop(innerContext)
          ),
          CupertinoDialogAction(
            child: Text(okText),
            isDestructiveAction: true,
            onPressed: () async =>  voids.signOut(context: context,innerContext: innerContext )
          )
        ],
      );
    };
    voids.showCupertinoDialogue(context: context, builder: builder );
  }

}