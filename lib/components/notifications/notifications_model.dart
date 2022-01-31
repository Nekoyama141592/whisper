// material
import 'package:flutter/material.dart';
// packages
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';


final notificationsProvider = ChangeNotifierProvider(
  (ref) => NotificationsModel()
);
class NotificationsModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // notifications
  Stream<QuerySnapshot<Map<String, dynamic>>> notificationStream = notificationsColRef(uid: firebaseAuthCurrentUser!.uid).where(isReadFieldKey,isEqualTo: false).limit(oneTimeReadCount).snapshots();
  NotificationsModel() {
    init();
  }

  Future<void> init() async {
    startLoading();
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

}