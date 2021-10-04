// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  User? currentUser;
  late DocumentSnapshot currentUserDoc;
  bool isLoading = false;
  List<String> likedPostIds = [];
  List<String> bookmarkedPostIds = [];
  List<dynamic> newLikeNotifications = [];
  List<dynamic> newFollowNotifications = [];
  List<dynamic> followingUids = [];

  MainModel() {
    init();
  }
  
  void init() async {
    startLoading();
    await setCurrentUser();
    getLikedPostIds();
    getPreservatedPostIds();
    getFollowingUids();
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
  }

  void getPreservatedPostIds() {
    
    try{
      List bookmarks = currentUserDoc['preservations'];
      bookmarks.forEach((bookmark) {
        bookmarkedPostIds.add(bookmark['postId']);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
    
  }

  void getFollowingUids() {
    followingUids = currentUserDoc['followingUids'];
  }

  void getNewNotifications () {
    List<dynamic> likeNotifications = currentUserDoc['likeNotifications'];
    List<dynamic> followNotifications = currentUserDoc['followNotifications'];
    likeNotifications.forEach((likeNotification){
      if (likeNotification['isRead'] == false) {
        newLikeNotifications.add(likeNotification);
      }
    });
    followNotifications.forEach((followNotification){
      if (followNotification['isRead'] == false) {
        newFollowNotifications.add(followNotification);
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