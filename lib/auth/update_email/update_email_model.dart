import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;
final updateEmailProvider = ChangeNotifierProvider(
  (ref) => UpdateEmailModel()
);

class UpdateEmailModel extends ChangeNotifier {

  String newEmail = "";

  Future verifyBeforeUpdateEmail(BuildContext context) async {
    final instance = FirebaseAuth.instance;
    final User? user = instance.currentUser;
    try{
      await user!.verifyBeforeUpdateEmail(newEmail);
    } catch(e) {
      print(e.toString());
    }
  }
}