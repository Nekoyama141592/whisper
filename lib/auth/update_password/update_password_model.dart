// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/lists.dart';
// models
import 'package:whisper/main_model.dart';

final updatePasswordProvider = ChangeNotifierProvider(
  (ref) => UpdatePasswordModel()
);

class UpdatePasswordModel extends ChangeNotifier {
  
  String newPassword = '';
  String confirmPassword = '';

  Future onUpdateButtonPressed({ required BuildContext context }) async {
    if (newPassword == confirmPassword) {
      if (newPassword.isEmpty && confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('フォームに新しいパスワードを入力してください')));
      } else if (commonPasswords.contains(newPassword)){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('弱いパスワードです。変更してください')));
      } else {
        await updatePassword(context: context);
      }
    } else {
      if (newPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('新しいパスワードを入力してください')));
      }
      if (confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('確認用パスワードを入力してください')));
      }
      if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('二つのパスワードが異なります')));
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('パスワードが更新されました'))
      );
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'weak-password':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('パスワードの強度が十分ではありません')));
        break;
        case 'requires-recent-login':
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('再認証が行われていません')));
        break;
      }
    }
  }

}