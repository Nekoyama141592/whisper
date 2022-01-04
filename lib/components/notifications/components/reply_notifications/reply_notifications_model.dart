// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;

final replyNotificationsProvider = ChangeNotifierProvider(
  (ref) => ReplyNotificationsModel()
);

class ReplyNotificationsModel extends ChangeNotifier {
  
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> notificationDocs = [];
  final Query<Map<String,dynamic>> query = replyNotificationsParentRef(uid: FirebaseAuth.instance.currentUser!.uid).orderBy(createdAtKey,descending: true);
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);

  ReplyNotificationsModel() {
    init();
  } 
  
  Future<void> init() async {
    startLoading();
    await getNotifications();
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

  Future<void> onRefresh() async {
    await getNewNotifications();
    refreshController.refreshCompleted();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await getNewNotifications();
    endLoading();
  }

  Future<void> onLoading() async {
    await getOldNotifications();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewNotifications() async {
    await voids.processNewDocs(query: query, docs: notificationDocs);
  }
  
  Future<void> getNotifications() async {
    await voids.processBasicDocs(query: query, docs: notificationDocs);
  }
  
  Future<void> getOldNotifications() async {
    await voids.processOldDocs(query: query, docs: notificationDocs);
  }

}
