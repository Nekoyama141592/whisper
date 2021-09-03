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
  List<String> likedPostIds = [];
  List<String> preservatedPostIds = [];

  int currentIndex = 0;
  MainModel() {
    init();
  }
  void init() async {
    startLoading();
    await setCurrentUser();
    await getLikedPostIds();
    await getPreservatedPostIds();
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

  void onTabTapped(int i) {
    currentIndex = i;
  }

  Future setCurrentUser() async {
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
    notifyListeners();
  }

  Future getLikedPostIds() async {
    try{
      await FirebaseFirestore.instance
      .collection('likes')
      .where('uid',isEqualTo: currentUser!.uid)
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          likedPostIds.add(doc['postId']);
        });
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future getPreservatedPostIds() async {
    await FirebaseFirestore.instance
    .collection('preservations')
    .where('uid',isEqualTo: currentUser!.uid)
    .get()
    .then((qshot) {
      qshot.docs.forEach((doc) {
        preservatedPostIds.add(doc['postId']);
      });
    });
  }
  Future logout(context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout!!!!!!!!!!!!!!!!!!!!!!!!');
    routes.toMyApp(context);
  }
}