import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {
  
  Future replyNotificationOfUser() async {
   
    try{
      
      WriteBatch batch = FirebaseFirestore.instance.batch();
      Map<String,dynamic> map = {
        'commentId': '',
        'comment': '',
        'createdAt': Timestamp.now(),
        'isRead': false,
        'uid': '',
      };
      List replyNotifications = [map];

      return FirebaseFirestore.instance.collection('users')
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          batch.update(
            doc.reference, 
            {
              'replyNotifications': replyNotifications,
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