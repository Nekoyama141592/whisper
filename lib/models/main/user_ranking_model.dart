// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/strings.dart';

final userRankingProvider = ChangeNotifierProvider(
  (ref) => UserRankingModel()
);

class UserRankingModel extends ChangeNotifier {
  bool isLoading = false;
  final Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection(usersFieldKey).orderBy(followerCountFieldKey,descending: true).limit(oneTimeReadCount);
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];
  RefreshController refreshController = RefreshController(initialRefresh: false);

  UserRankingModel() {
    init();
  }

  Future<void> init () async {
    startLoading();
    await query.get().then((qshot) {
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
    await query
    .startAfterDocument(userDocs.last).get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
        userDocs.add(doc);
      });
    });
  }
}