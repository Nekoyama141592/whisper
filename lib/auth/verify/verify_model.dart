// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
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

  void setCurrentUser() => currentUser = firebaseAuthCurrentUser();

  Future<void>  setTimer({ required BuildContext context}) async => timer = Timer.periodic(Duration(seconds: verifyMailIntervalSeconds), (timer) async => await checkEmailVerified(context: context ));

  Future<void> checkEmailVerified({ required BuildContext context}) async {
    setCurrentUser();
    await currentUser!.reload();
    if (currentUser!.emailVerified) {
      timer.cancel();
      routes.toMyApp(context);
    }
  }

  Future<void> onButtonPressed({ required BuildContext context}) async {
    await setTimer(context: context);
    await checkEmailVerified(context: context);
  }
}