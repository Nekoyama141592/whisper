// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/counts.dart';

final userRankingProvider = ChangeNotifierProvider(
  (ref) => UserRankingModel()
);

class UserRankingModel extends ChangeNotifier {
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  UserRankingModel() {
    init();
  }

  Future<void> init () async {
    startLoading();
    await FirebaseFirestore.instance.collection('users').orderBy('followersCount',descending: true).limit(oneTimeReadCount).get().then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) { userDocs.add(doc); });
    });
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

  Future<void> onLoading() async {
    await getMoreUsers();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getMoreUsers() async {
    await FirebaseFirestore.instance
    .collection('posts')
    .orderBy('followersCount',descending: true)
    .startAfterDocument(userDocs.last)
    .limit(oneTimeReadCount)
    .get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        userDocs.add(doc);
      });
    });
  }
}