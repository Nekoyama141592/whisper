import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whisper/constants/others.dart';

import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/voids.dart';
import 'package:whisper/l10n/l10n.dart';
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

  Future<void> login({ required BuildContext context}) async {
    final L10n l10n = returnL10n(context: context)!;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      routes.toMyApp(context);
    } on FirebaseAuthException catch(e) {
      String msg = "";
      switch(e.code) {
        case 'invalid-email':
          msg = l10n.invalidEmail;
        break;
        case 'user-disabled':
          msg = l10n.userDisabled;
        break;
        case 'user-not-found':
          msg = l10n.authUserNotFound;
        break;
        case 'wrong-password':
          msg = l10n.wrongPassword;
        break;
      }
      showBasicFlutterToast(context: context, msg: msg);
    } 
  }
  
}
