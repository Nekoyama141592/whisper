// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  // base
  bool isLoading = false;
  // user
  User? currentUser;
  late DocumentSnapshot currentUserDoc;
  
  List<String> likedPostIds = [];
  List<String> bookmarkedPostIds = [];
  List<dynamic> followingUids = [];
  List<dynamic> likedCommentIds = [];
  List<dynamic> likedComments = [];
  List<dynamic> bookmarks = [];
  List<dynamic> likes = [];
  List<dynamic> readPosts = [];
  List<dynamic> readPostIds = [];
  List<dynamic> commentNotifications = [];
  List<String> readNotificationsIds = [];
  List<dynamic> replyNotifications = [];
  List<String> notificationIds = [];
  bool newNotificationExists = false;

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
    getReadNotificationIds();
    getReplyNotifications();
    setNotificationIds();
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

  void setCommentNotifications() {
    commentNotifications = currentUserDoc['commentNotifications'];
  }

  Future getReadNotificationIds() async {
    final prefs = await SharedPreferences.getInstance();
    readNotificationsIds = prefs.getStringList('readNotificationIds') ?? [];
    print(readNotificationsIds);
  }

  void getReplyNotifications() {
    replyNotifications = currentUserDoc['replyNotifications'];
  }

  void setNotificationIds() {
    replyNotifications.forEach((replyNotification) {
      final notificationId = replyNotification['notificationId'];
      if (!readNotificationsIds.contains(notificationId)) {
        newNotificationExists = true;
      }
      notificationIds.add(notificationId);
    });
    commentNotifications.forEach((commentNotification) {
      final notificationId = commentNotification['notificationId'];
      if (!readNotificationsIds.contains(notificationId)) {
        newNotificationExists = true;
      }
      notificationIds.add(notificationId);
    });
  }
  
}