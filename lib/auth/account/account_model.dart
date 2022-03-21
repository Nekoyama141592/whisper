// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  
  User? currentUser;

  AccountModel() {
    init();
  }

  void init() {
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

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
      switch(e.code) {
        case 'invalid-email':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのメールアドレスは不敵です')));
        break;
        case 'wrong-password':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('パスワードが違います')));
        break;
      }
    }
  }

  void showDeleteUserDialog({ required BuildContext context, required MainModel mainModel }) {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final String title = 'ユーザー削除';
    final String content = '一度削除したら、復元はできません。本当に削除しますか？';
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text(cancelMsg),
            onPressed: () {
              Navigator.pop(innerContext);
            },
          ),
          CupertinoDialogAction(
            child: Text(okMsg),
            isDestructiveAction: true,
            onPressed: () async {
              if (currentUser!.uid == mainModel.currentWhisperUser.uid) {
                Navigator.pop(innerContext);
                routes.toIsFinishedPage(context: context,title: 'ユーザーを消去しました',text: 'ユーザーも投稿もコメントも削除されました。お疲れ様でした');
                await deleteUserFromFireStoreAndFirebaseAuth(context: context, currentWhisperUser: currentWhisperUser);
              }
            },
          ),
        ],
      );
    };
    voids.showCupertinoDialogue(context: context,builder: builder );
  }

  Future<void> deleteUserFromFireStoreAndFirebaseAuth({ required BuildContext context, required WhisperUser currentWhisperUser}) async {
    await returnUserMetaDocRef(uid: currentWhisperUser.uid).delete().then((_) async {
      await currentUser!.delete();  
    });
  }

  void showSignOutDialog({required BuildContext context}) {
    final String title = 'ログアウト';
    final String content = 'ログアウトしますか?';
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text(cancelMsg),
            onPressed: () {
              Navigator.pop(innerContext);
            },
          ),
          CupertinoDialogAction(
            child: Text(okMsg),
            isDestructiveAction: true,
            onPressed: () async { voids.signOut(context: context,innerContext: innerContext ); }
          )
        ],
      );
    };
    voids.showCupertinoDialogue(context: context, builder: builder );
  }

}