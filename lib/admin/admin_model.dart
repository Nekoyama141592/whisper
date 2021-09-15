import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {
  
  Future addLikesToPost() async {
   
    try{
      WriteBatch batch = FirebaseFirestore.instance.batch();
      Map<String, dynamic> map = {
        'uid': '',
        'createdAt': Timestamp.now(),
      };
      final List likes = [map];
      return FirebaseFirestore.instance.collection('posts')
      .get()
      .then((qshot) {
        qshot.docs.forEach((doc) {
          batch.update(
            doc.reference, 
            {
              'likes': likes,
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