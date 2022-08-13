// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/l10n/l10n.dart';

final verifyPasswordResetProvider = ChangeNotifierProvider((ref) => VerifyPasswordResetModel());

class VerifyPasswordResetModel extends ChangeNotifier {
  
  String email = '';

  Future<void> sendPasswordResetEmail ({ required BuildContext context }) async {
    final instance = FirebaseAuth.instance;
    final L10n l10n = returnL10n(context: context)!;
    try{
      await instance.sendPasswordResetEmail(email: email);
      Navigator.pop(context);
      await voids.showBasicFlutterToast(context: context, msg: l10n.sendedEmail(email));
    } on FirebaseAuthException catch(e) {
      String msg = "";
      switch(e.code) {
        case 'auth/invalid-email':
          msg = l10n.authInvalidEmail;
        break;
        case 'auth/user-not-found':
          msg = l10n.authUserNotFound;
        break;
      } 
      await voids.showBasicFlutterToast(context: context, msg: msg);
    } 
  }
}