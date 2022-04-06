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
        showBasicFlutterToast(context: context, msg: 'そのメールアドレスは不適です' );
        break;
        case 'user-disabled':
        showBasicFlutterToast(context: context, msg: 'そのメールアドレスは無効化されています' );
        break;
        case 'user-not-found':
        showBasicFlutterToast(context: context, msg: 'そのメールアドレスを持つユーザーが見つかりません');
        break;
        case 'wrong-password':
        showBasicFlutterToast(context: context, msg: 'パスワードが違います' );
        break;
      }
    } 
  }
  
}
