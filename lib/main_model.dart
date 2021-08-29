import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {
  Future logout(context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout!!!!!!!!!!!!!!!!!!!!!!!!');
    routes.toMyApp(context);
  }
}