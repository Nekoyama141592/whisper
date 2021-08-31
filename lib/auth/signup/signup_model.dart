import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:whisper/constants/routes.dart' as routes;

final signupProvider = ChangeNotifierProvider(
  (ref) => SignupModel()
);

class SignupModel extends ChangeNotifier {
  String userName = "";
  String email = "";
  String password = "";
  late UserCredential result;
  late User? user;
  // image
  bool isLoading = false;
  XFile? xfile;
  late File imageFile;
  String downloadURL = '';
  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xfile = await _picker.pickImage(source: ImageSource.gallery);
    imageFile = File(xfile!.path);
    notifyListeners();
  }

  Future uploadImage() async {
    if (userName.isEmpty) {
      print('userNameを入力してください');
    }
    try {
      await FirebaseStorage.instance
      .ref()
      .child('users')
      .child('$userName' + '.png')
      .putFile(imageFile);
      downloadURL = await FirebaseStorage.instance
      .ref()
      .child('users')
      .child('$userName' + '.png')
      .getDownloadURL();
    } catch(e) {
      print(e.toString());
    }
    return downloadURL;
  }

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
    final imageURL = await uploadImage();
    await FirebaseFirestore.instance
    .collection('users').add({
      'email': email,
      'uid' : uid,
      'subUserName': uid,
      'point': 0,
      'imageURL': imageURL,
      'userName': userName,
    });
  }
}