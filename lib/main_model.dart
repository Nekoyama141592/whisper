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
  late DocumentSnapshot currentUserDoc;
  bool isLoading = true;
  List<String> likedPostIds = [];
  List<String> preservatedPostIds = [];
  List<dynamic> newNotifications = [];

  MainModel() {
    init();
  }
  void init() async {
    startLoading();
    await setCurrentUser();
    getLikedPostIds();
    getPreservatedPostIds();
    getNewNotifications();
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

  void getLikedPostIds() {
    try{
      List likes = currentUserDoc['likes'];
      print(likes.length.toString() + "  likesLength");
      likes.forEach((like) {
        likedPostIds.add(like['likedPostId']);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
    print(likedPostIds.length.toString() + "  likedPostIds");
    
  }

  void getPreservatedPostIds() {
    try{
      List preservations = currentUserDoc['preservations'];
      print(preservations.length.toString() + "  preservationsLength");
      preservations.forEach((preservation) {
        preservatedPostIds.add(preservation['postId']);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
    print(preservatedPostIds.length.toString() + '  preservatedPostIds');
  }

  void getNewNotifications () {
    List<dynamic> likeNotifications = currentUserDoc['likeNotifications'];
    List<dynamic> followNotifications = currentUserDoc['followNotifications'];
    likeNotifications.forEach((likeNotification){
      if (likeNotification['isRead'] == false) {
        newNotifications.add(likeNotification);
      }
    });
    followNotifications.forEach((followNotification){
      if (followNotification['isRead'] == false) {
        newNotifications.add(followNotification);
      }
    });
    notifyListeners();
  }
  Future logout(context) async {
    await FirebaseAuth.instance.signOut();
    print('Logout!!!!!!!!!!!!!!!!!!!!!!!!');
    routes.toMyApp(context);
  }
}