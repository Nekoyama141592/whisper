// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:pull_to_refresh/pull_to_refresh.dart';
// common
import 'package:whisper/constants/enums.dart';

abstract class DocsModel extends ChangeNotifier {

  DocsModel({required this.basicDocType,required this.query}) {
    init();
  }
  Future<void> init() async => await onReload();

  RefreshController refreshController = RefreshController(initialRefresh: false);
  List<DocumentSnapshot<Map<String,dynamic>>> docs = [];

  final BasicDocType basicDocType;
  final Query<Map<String,dynamic>> query;
  bool isLoading = false;
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh() async {
    await getNewDocs();
    refreshController.refreshCompleted();
    notifyListeners(); 
  }

  Future<void> onReload() async {
    startLoading();
    await getDocs();
    notifyListeners();
  }

  Future<void> onLoading() async {
    await getOldDocs();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getNewDocs();
  Future<void> getDocs();
  Future<void> getOldDocs();

}