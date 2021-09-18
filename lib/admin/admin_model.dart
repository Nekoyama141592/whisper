import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {
  
  Future addFollowNotificationsToUser() async {
   
    try{
      WriteBatch batch = FirebaseFirestore.instance.batch();
      Map<String, dynamic> map = {
        'uid': '',
        'createdAt': Timestamp.now(),
        'isRead': false,
      };
      final List followNotifications = [map];
      return FirebaseFirestore.instance.collection('users')
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          batch.update(
            doc.reference, 
            {
              'followNotifications': followNotifications,
            }
          );
        });
        return batch.commit();
      });
    } catch(e) {
      print(e.toString());
    }
  }
}