// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/lists.dart';

final updatePasswordProvider = ChangeNotifierProvider(
  (ref) => UpdatePasswordModel()
);

class UpdatePasswordModel extends ChangeNotifier {
  
  String newPassword = '';
  String confirmPassword = '';

  Future onUpdateButtonPressed({ required BuildContext context }) async {
    if (newPassword == confirmPassword) {
      if (newPassword.isEmpty && confirmPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: 'フォームに新しいパスワードを入力してください');
      } else if (commonPasswords.contains(newPassword)){
        voids.showBasicFlutterToast(context: context, msg: '弱いパスワードです。変更してください');
      } else {
        await updatePassword(context: context);
      }
    } else {
      if (newPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: '新しいパスワードを入力してください');
      }
      if (confirmPassword.isEmpty) {
        voids.showBasicFlutterToast(context: context, msg: '確認用パスワードを入力してください');
      }
      if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
        voids.showBasicFlutterToast(context: context, msg: '二つのパスワードが異なります');
      }
    }
  }
  
  Future updatePassword({ required BuildContext context}) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try {
      await user!.updatePassword(newPassword);
      Navigator.pop(context);
      Navigator.pop(context);
      voids.showBasicFlutterToast(context: context, msg: 'パスワードが更新されました');
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'weak-password':
        voids.showBasicFlutterToast(context: context, msg: 'パスワードの強度が十分ではありません');
        break;
        case 'requires-recent-login':
        voids.showBasicFlutterToast(context: context, msg: '再認証が行われていません');
        break;
      }
    }
  }

}