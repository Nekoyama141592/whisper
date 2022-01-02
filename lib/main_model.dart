// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/voids.dart' as voids;

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  // base
  bool isLoading = false;
  // user
  User? currentUser;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  late SharedPreferences prefs;

  List<String> likedPostIds = [];
  List<String> bookmarkedPostIds = [];
  List<dynamic> followingUids = [];
  List<dynamic> likedCommentIds = [];
  List<dynamic> likedComments = [];
  List<dynamic> bookmarks = [];
  List<dynamic> likes = [];
  List<dynamic> readPosts = [];
  List<dynamic> readPostIds = [];
  List<String> readNotificationIds = [];
  List<dynamic> likedReplys = [];
  List<dynamic> likedReplyIds = [];
  // notifications
  List<dynamic> commentNotifications = [];
  List<dynamic> replyNotifications = [];
  // mutes 
  List<dynamic> mutesUids = [];
  List<dynamic> mutesIpv6s = [];
  List<dynamic> mutesIpv6AndUids = [];
  List<String> mutesReplyIds = [];
  List<String> mutesCommentIds = [];
  List<String> mutesPostIds = [];
  // block
  List<dynamic> blocksUids = [];
  List<dynamic> blocksIpv6s = [];
  List<dynamic> blocksIpv6AndUids = [];

  MainModel() {
    init();
  }
  
  void init() async {
    startLoading();
    prefs = await SharedPreferences.getInstance();
    await setCurrentUser();
    getReadNotificationIds();
    getNotificationIds();
    getLikedPostIds();
    getLikesReplys();
    getBookmarkedPostIds();
    getFollowingUids();
    getLikedCommentIds();
    getReadPost();
    setMutesAndBlocks();
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

  Future<void> setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
    try{
      currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
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
    followingUids.add(currentUser!.uid);
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

  void setMutesAndBlocks() {
    voids.setMutesAndBlocks(prefs: prefs, currentUserDoc: currentUserDoc, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    mutesReplyIds = prefs.getStringList('mutesReplyIds') ?? [];
    mutesCommentIds = prefs.getStringList('mutesCommentIds') ?? [];
  }

  void getReadNotificationIds() {
    readNotificationIds = prefs.getStringList('readNotificationIds') ?? [];
  }

  void getNotificationIds() {
    commentNotifications = currentUserDoc['commentNotifications'];
    commentNotifications.removeWhere((notification) => isNotiRecentNotification(notification: notification) );
    replyNotifications = currentUserDoc['replyNotifications'];
    replyNotifications.removeWhere((notification) => isNotiRecentNotification(notification: notification) );
  }

  void getLikesReplys() {
    likedReplys = currentUserDoc['likedReplys'];
    likedReplys.forEach((likesReply) {
      likedReplyIds.add(likesReply['likedReplyId']);
    });
  }

  Future<void> regetCurrentUserDoc() async {
    currentUser = FirebaseAuth.instance.currentUser;
    currentUserDoc =  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id).get();
    notifyListeners();
  }

  Future<void> addNotificationIdToReadNotificationIds({ required Map<String,dynamic> notification}) async {
    final String notificationId = notification['notificationId'];
    readNotificationIds.add(notificationId);
    notifyListeners();
    await prefs.setStringList('readNotificationIds', readNotificationIds);
  }

  Future<void> regetNotifications() async {
    await regetCurrentUserDoc();
    getNotificationIds();
    notifyListeners();
  }
  
  void reload() {
    notifyListeners();
  }
}