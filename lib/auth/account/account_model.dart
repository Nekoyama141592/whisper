
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;
final accountProvider = ChangeNotifierProvider(
  (ref) => AccountModel()
);

enum WhichState {
  initialValue,
  updateEmail,
  updatePassword,     
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
  
  Future reauthenticateWithCredential (BuildContext context,User? currentUser)  async {
    
    currentUser = FirebaseAuth.instance.currentUser;
    final email = currentUser!.email;
    final credential = EmailAuthProvider.credential(email: email!, password: password);
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try {
      await user!.reauthenticateWithCredential(credential);
      if (whichState == WhichState.updatePassword) {
        routes.toUpdatePassword(context, currentUser);
      }
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'user-mismatch':
        print('それは今、お使いのアカウントではありません');
        break;
        case 'user-not-found':
        print('そのようなユーザーは見つかりません');
        break;
        case 'invalid-email':
        print('そのメールアドレスは運営によって無効化されています');
        break;
        case 'invalid-credential':
        print('invalid-credential');
        break;
        case 'wrong-password':
        print('passwordが違います');
        break;
      }
    }
  }
}