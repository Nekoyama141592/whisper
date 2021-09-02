import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;

final verifyProvider = ChangeNotifierProvider(
  (ref) => VerifyModel()
);

class VerifyModel extends ChangeNotifier {
  User? currentUser;

VerifyModel() {
  init();
}
void init() {
  setCurrentUser();
  currentUser!.sendEmailVerification();
}

void setCurrentUser() {
  currentUser = FirebaseAuth.instance.currentUser;
}

  Future checkEmailVerified(context) async {
    currentUser = FirebaseAuth.instance.currentUser;
    await currentUser!.reload();
    if (currentUser!.emailVerified) {
      routes.toMyApp(context);
    } else {
      throw('認証に失敗しました');
    }
  }
}