import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;
final updatePasswordProvider = ChangeNotifierProvider(
  (ref) => UpdatePasswordModel()
);

class UpdatePasswordModel extends ChangeNotifier {
  
  String newPassword = '';
  String confirmPassword = '';

  Future onUpdateButtonPressed(context) async {
    if (newPassword == confirmPassword) {
      if (newPassword.isEmpty && confirmPassword.isEmpty) {
        print('フォームに新しいパスワードを入力してください');
      } else {
        await updatePassword(context);
      }
    } else {
      if (newPassword.isEmpty) {
        print('新しいパスワードを入力してください');
      }
      if (confirmPassword.isEmpty) {
        print('確認用パスワードを入力してください');
      }
      if (newPassword.isNotEmpty && confirmPassword.isNotEmpty) {
        print('二つのパスワードが異なります。');
      }
    }
  }
  
  Future updatePassword(context) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try {
      await user!.updatePassword(newPassword);
      routes.toMyApp(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('パスワードが更新されました'))
      );
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'weak-password':
        print('パスワードの強度が十分ではありません');
        break;
        case 'requires-recent-login':
        print('再認証が行われていません');
        break;
      }
    }
  }

}