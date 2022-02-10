import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/voids.dart';
final loginProvider = ChangeNotifierProvider(
  (ref) => LoginModel()
);

class LoginModel extends ChangeNotifier {
  String email = "";
  String password = "";
  bool isLoading = false;
  bool isObscure = true;
  
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void toggleIsObsucure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  Future login(context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      routes.toMyApp(context);
    } on FirebaseAuthException catch(e) {
      switch(e.code) {
        case 'invalid-email':
        showSnackBar(context: context, text: 'そのメールアドレスは不適です' );
        break;
        case 'user-disabled':
        showSnackBar(context: context, text: 'そのメールアドレスは無効化されています' );
        break;
        case 'user-not-found':
        showSnackBar(context: context, text: 'そのメールアドレスを持つユーザーが見つかりません');
        break;
        case 'wrong-password':
        showSnackBar(context: context, text: 'パスワードが違います' );
        break;
      }
    } 
  }
  
}
