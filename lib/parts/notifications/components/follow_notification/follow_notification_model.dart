import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final followNotificationProvider = ChangeNotifierProvider(
  (ref) => FollowNotificationModel()
);
class FollowNotificationModel extends ChangeNotifier {
  
  bool isLoading = false;
  List<dynamic> notifications = [];
  User? currentUser;
  late DocumentSnapshot currentUserDoc;

  FollowNotificationModel() {
    init();
  }

  void init() async {
    startLoading();
    await setCurrentUser();
    getNotifications();
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
          currentUserDoc = doc;
        });
      });
    } catch(e) {
      print(e.toString());
    }
    notifyListeners();
  }

  void getNotifications() {
    notifications = currentUserDoc['followNotifications'];
    notifyListeners();
  }
}