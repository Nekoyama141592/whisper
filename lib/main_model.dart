import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/constants/routes.dart' as routes;

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  User? currentUser;
  late DocumentSnapshot currentUserdoc;
  bool isLoading = true;
  MainModel() {
    init();
  }
  void init() async {
    startLoading();
    currentUser = FirebaseAuth.instance.currentUser;
    try{
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid',isEqualTo: currentUser!.uid)
      .limit(1)
      .get()
      .then((qshot){
        qshot.docs.forEach((DocumentSnapshot doc) {
          currentUserdoc = doc;
        });
      });
    } catch(e) {
      print(e.toString());
    }
    endLoading();
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
  Future logout(context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout!!!!!!!!!!!!!!!!!!!!!!!!');
    routes.toMyApp(context);
  }
}