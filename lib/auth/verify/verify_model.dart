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
  int verifyTimes = 0;

  VerifyModel() {
    init();
  }
  void init() {
    setCurrentUser();
    currentUser!.sendEmailVerification();
    Timer.periodic(Duration(seconds: 5), (timer) async {
      await currentUser!.reload();
    });
  }

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  void checkEmailVerified(context)  {
    if (currentUser!.emailVerified) {
      routes.toMyApp(context);
    } else {
      throw('認証に失敗しました');
    }
  }
}