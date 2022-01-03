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
    voids.showCupertinoDialogue(context: context, title: 'ログアウト', content: 'ログアウトしますか?', action: () async { await voids.signOut(context); });
  }

  
}