// dart
import 'dart:async';
// material
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final updateEmailProvider = ChangeNotifierProvider(
  (ref) => UpdateEmailModel()
);

class UpdateEmailModel extends ChangeNotifier {

  String newEmail = "";

  Future verifyBeforeUpdateEmail({ required BuildContext context }) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    await user!.verifyBeforeUpdateEmail(newEmail);
  }
}