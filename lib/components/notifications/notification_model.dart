// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationProvider = ChangeNotifierProvider(
  (ref) => NotificationModel()
);

class NotificationModel extends ChangeNotifier {
  
  Future updateReadNotificationIdsOfCurrentUser(DocumentSnapshot currentUserDoc,String notificationId,List<dynamic> readNotificationIds) async {
    try{
      readNotificationIds.add(notificationId);
      notifyListeners();
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'readNotificationIds': readNotificationIds
      });
    } catch(e) {
      print(e.toString());
    }
  }
}