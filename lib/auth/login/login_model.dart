import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;
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
      await FirebaseAuth.instance
      .signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      routes.toMyApp(context);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.toString());
      }
    }
  }
  
}
