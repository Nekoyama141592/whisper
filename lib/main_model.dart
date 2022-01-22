// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/many_update_user/many_update_user.dart';

final mainProvider = ChangeNotifierProvider(
  (ref) => MainModel()
);

class MainModel extends ChangeNotifier {

  // base
  bool isLoading = false;
  // user
  User? currentUser;
  late DocumentSnapshot<Map<String,dynamic>> currentUserDoc;
  late UserMeta userMeta;
  late WhisperUser currentWhisperUser;
  late WhisperManyUpdateUser manyUpdateUser;
  late SharedPreferences prefs;

  List<String> likePostIds = [];
  List<String> bookmarksPostIds = [];
  List<dynamic> followingUids = [];
  List<dynamic> likeCommentIds = [];
  List<dynamic> likeComments = [];
  List<dynamic> bookmarks = [];
  List<dynamic> likes = [];
  List<dynamic> readPosts = [];
  List<dynamic> readPostIds = [];
  List<String> readNotificationIds = [];
  List<dynamic> likeReplys = [];
  List<dynamic> likeReplyIds = [];
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
    getLikePostIds();
    getLikesReplys();
    getBookmarksPostIds();
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
    final currentUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    currentWhisperUser = fromMapToWhisperUser(userMap: currentUserDoc.data()!);
    final userMetaDoc = await FirebaseFirestore.instance.collection(userMetaKey).doc(currentUser!.uid).get();
    userMeta = fromMapToUserMeta(userMetaMap: userMetaDoc.data()!);
    final manyUpdateUserDoc = await FirebaseFirestore.instance.collection(manyUpdateUsersKey).doc(currentUser!.uid).get();
    manyUpdateUser = fromMapToManyUpdateUser(manyUpdateUserMap: manyUpdateUserDoc.data()!);
    notifyListeners();
  }

  void getLikePostIds() {
    try{
      likes = userMeta.likes;
      likes.forEach((like) {
        likePostIds.add(like[likePostIdKey]);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
  }

  void getBookmarksPostIds() {
    
    try{
      bookmarks = userMeta.bookmarks;
      bookmarks.forEach((bookmark) {
        bookmarksPostIds.add(bookmark[postIdKey]);
      });
      notifyListeners();
    } catch(e) {
      print(e.toString());
    }
  }

  void getFollowingUids() {
    followingUids = userMeta.followingUids;
    followingUids.add(currentUser!.uid);
  }

  void getLikedCommentIds() {
    likeComments = userMeta.likeComments;
    likeComments.forEach((likedComment) {
      likeCommentIds.add(likedComment[commentIdKey]);
    });
    notifyListeners();
  }
  
  void getReadPost() {
    readPosts = userMeta.readPosts;
    readPosts.forEach((readPost) {
      readPostIds.add(readPost[postIdKey]);
    });
  }

  void setMutesAndBlocks() {
    voids.setMutesAndBlocks(prefs: prefs, manyUpdateUser: manyUpdateUser, mutesIpv6AndUids: mutesIpv6AndUids, mutesIpv6s: mutesIpv6s, mutesUids: mutesUids, mutesPostIds: mutesPostIds, blocksIpv6AndUids: blocksIpv6AndUids, blocksIpv6s: blocksIpv6s, blocksUids: blocksUids);
    mutesReplyIds = prefs.getStringList(mutesReplyIdsKey) ?? [];
    mutesCommentIds = prefs.getStringList(mutesCommentIdsKey) ?? [];
  }

  void getReadNotificationIds() {
    readNotificationIds = prefs.getStringList(readNotificationIdsKey) ?? [];
  }

  void getLikesReplys() {
    likeReplys = userMeta.likeReplys;
    likeReplys.forEach((likesReply) {
      likeReplyIds.add(likesReply[likeReplyIdKey]);
    });
  }

  Future<void> regetCurrentUserDoc() async {
    currentUser = FirebaseAuth.instance.currentUser;
    final currentUserDoc =  await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    userMeta = fromMapToUserMeta(userMetaMap: currentUserDoc.data()!);
    notifyListeners();
  }

  Future<void> addNotificationToReadNotificationIds({ required Map<String,dynamic> notification}) async {
    final String notificationId = notification[notificationIdKey];
    readNotificationIds.add(notificationId);
    notifyListeners();
    await prefs.setStringList(readNotificationIdsKey, readNotificationIds);
  }
  
  void reload() {
    notifyListeners();
  }
}