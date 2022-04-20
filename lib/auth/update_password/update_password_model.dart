// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/lists.dart';
import 'package:whisper/l10n/l10n.dart';

final updatePasswordProvider = ChangeNotifierProvider(
  (ref) => UpdatePasswordModel()
);

class UpdatePasswordModel extends ChangeNotifier {
  
  String newPassword = '';
  String confirmPassword = '';

  Future<void> onUpdateButtonPressed({ required BuildContext context }) async {
    final L10n l10n = returnL10n(context: context)!;
    final String pleaseInputNewPassword = l10n.pleaseInputNewPassword;
    if (newPassword == confirmPassword) {
      if (newPassword.isEmpty && confirmPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: pleaseInputNewPassword);
      } else if (commonPasswords.contains(newPassword)){
        voids.showBasicFlutterToast(context: context, msg: l10n.weakPasswordMsg);
      } else {
        await updatePassword(context: context);
      }
    } else {
      if (newPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: pleaseInputNewPassword);
      }
      if (confirmPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: l10n.pleaseInputConfirmPassword);
      }
      if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
        voids.showBasicFlutterToast(context: context, msg: l10n.differentPasswordMsg);
      }
    }
  }
  
  Future<void> updatePassword({ required BuildContext context}) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    final L10n l10n = returnL10n(context: context)!;
    try {
      await user!.updatePassword(newPassword);
      Navigator.pop(context);
      Navigator.pop(context);
      voids.showBasicFlutterToast(context: context, msg: l10n.updatedMsg);
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'weak-password':
        voids.showBasicFlutterToast(context: context, msg: l10n.weakPasswordMsg);
        break;
        case 'requires-recent-login':
        voids.showBasicFlutterToast(context: context, msg: l10n.pleaseReauthenticate);
        break;
      }
    }
  }

}