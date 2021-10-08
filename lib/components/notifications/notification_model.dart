// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final notificationProvider = ChangeNotifierProvider(
  (ref) => NotificationModel()
);

class NotificationModel extends ChangeNotifier {
  
  late SharedPreferences prefs;
  bool isLoading = false;
  List<String> localReadNotificationIds = [];

  NotificationModel() {
    init();
  }
  
  Future init() async {
    startLoading();
    await setPrefs();
    getReadNotificationIds();
    endLoading();
  }

  void startLoading() {
    isLoading = true;
  }

  Future setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void getReadNotificationIds() {
    localReadNotificationIds = prefs.getStringList('readNotificationIds') ?? [];
  }

  void endLoading() {
    isLoading = false;
  }

  Future resetReadNotificationIdsOfCurrentUser(String notificationId) async {
    localReadNotificationIds.add(notificationId);
    localReadNotificationIds.remove(null);
    notifyListeners();
    await prefs.setStringList('readNotificationIds', localReadNotificationIds);
    print('success');
  }
}