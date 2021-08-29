import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/constants/routes.dart' as routes;

final signupProvider = ChangeNotifierProvider(
  (ref) => SignupModel()
);

class SignupModel extends ChangeNotifier {
  String email = "";
  String password = "";
  late UserCredential result;
  late User? user;

  Future signup(context) async {
    try{
      result = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      user = result.user;
      addUserToFireStore(user!.uid);
      routes.toMyApp(context);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'emain-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e.toString());
      }
    }
  }
  Future addUserToFireStore(uid) async {
    await FirebaseFirestore.instance
    .collection('users').add({
      'email': email,
      'uid' : uid,
      'subUserName': uid,
      'point': 0,
    });
  }
}