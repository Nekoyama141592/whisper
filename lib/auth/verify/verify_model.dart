// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/ints.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

final verifyProvider = ChangeNotifierProvider(
  (ref) => VerifyModel()
);

class VerifyModel extends ChangeNotifier {
  User? currentUser;
  late Timer timer;

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

  Future  setTimer(context) async {
    timer = Timer.periodic(Duration(seconds: verifyMailIntervalSeconds), (timer) async {
      await checkEmailVerified(context);
    });
  }

  Future checkEmailVerified(context) async {
    setCurrentUser();
    await currentUser!.reload();
    if (currentUser!.emailVerified) {
      timer.cancel();
      routes.toMyApp(context);
    }
  }
}