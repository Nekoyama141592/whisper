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
  User? currentUser = firebaseAuthCurrentUser();
  late Timer timer;

  VerifyModel() {
    init();
  }
  Future<void> init() async => await currentUser!.sendEmailVerification();

  Future<void>  setTimer({ required BuildContext context}) async => timer = Timer.periodic(Duration(seconds: verifyMailIntervalSeconds), (timer) async => await checkEmailVerified(context: context ));

  Future<void> checkEmailVerified({ required BuildContext context}) async {
    currentUser = firebaseAuthCurrentUser();
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