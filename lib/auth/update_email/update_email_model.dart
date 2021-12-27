// dart
import 'dart:async';
// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;

final updateEmailProvider = ChangeNotifierProvider(
  (ref) => UpdateEmailModel()
);

class UpdateEmailModel extends ChangeNotifier {

  String newEmail = "";

  Future verifyBeforeUpdateEmail(BuildContext context) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try{
      await user!.verifyBeforeUpdateEmail(newEmail);
    } catch(e) {
      print(e.toString());
    }
  }

  void showSignOutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context, 
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text('ログアウト'),
          content: Text('ログアウトしますか？'),
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
              onPressed: () async {
                await voids.signOut(context);
              },
            )
          ],
        );
      }
    );
  }

  
}