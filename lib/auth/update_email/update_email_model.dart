// dart
import 'dart:async';
// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;

final updateEmailProvider = ChangeNotifierProvider(
  (ref) => UpdateEmailModel()
);

class UpdateEmailModel extends ChangeNotifier {

  String newEmail = "";

  Future verifyBeforeUpdateEmail({ required BuildContext context}) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    await user!.verifyBeforeUpdateEmail(newEmail);
  }

  void showSignOutDialog({ required BuildContext context}) {
    final String title = 'ログアウト';
    final String content = 'ログアウトしますか?';
    final builder = (innerContext) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          CupertinoDialogAction(
            child: const Text(cancelText),
            onPressed: () {
              Navigator.pop(innerContext);
            },
          ),
          CupertinoDialogAction(
            child: Text(okText),
            isDestructiveAction: true,
            onPressed: () async => await voids.signOut(context: context, innerContext: innerContext)
          ),
        ],
      );
    };
    voids.showCupertinoDialogue(context: context,builder: builder );
  }

  
}