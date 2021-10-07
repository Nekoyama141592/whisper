// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  User? currentUser;
  late DocumentSnapshot currentUserDoc;
  bool isLoading = false;
  List<String> likedPostIds = [];
  List<String> bookmarkedPostIds = [];
  List<dynamic> followingUids = [];
  List<dynamic> likedCommentIds = [];
  List<dynamic> likedComments = [];
  List<dynamic> bookmarks = [];
  List<dynamic> likes = [];
  List<dynamic> readPosts = [];
  List<dynamic> readPostIds = [];
  List<dynamic> readNotificationsIds = [];
  List<dynamic> replyNotifications = [];

  MainModel() {
    init();
  }
  
  void init() async {
    startLoading();
    await setCurrentUser();
    getLikedPostIds();
    getBookmarkedPostIds();
    getFollowingUids();
    getLikedCommentIds();
    getReadPost();
    getReadNotifiationIds();
    getReplyNotifications();
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
      likes = currentUserDoc['likes'];
      likes.forEach((like) {
        likedPostIds.add(like['likedPostId']);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
  }

  void getBookmarkedPostIds() {
    
    try{
      bookmarks = currentUserDoc['bookmarks'];
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

  void getLikedCommentIds() {
    likedComments = currentUserDoc['likedComments'];
    likedComments.forEach((likedComment) {
      likedCommentIds.add(likedComment['commentId']);
    });
    notifyListeners();
  }
  
  void getReadPost() {
    readPosts = currentUserDoc['readPosts'];
    readPosts.forEach((readPost) {
      readPostIds.add(readPost['postId']);
    });
  }

  void getReadNotifiationIds() {
    List<dynamic> readNotifications = currentUserDoc['readNotificationIds'];
    readNotifications.forEach((readNotification) {
      readNotificationsIds.add(readNotification['notificationId']);
    });
  }

  void getReplyNotifications() {
    replyNotifications = currentUserDoc['replyNotifications'];
  }
  
}