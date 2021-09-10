import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final adminProvider = ChangeNotifierProvider(
  (ref) => AdminModel()
);

class AdminModel extends ChangeNotifier {

  Future addDescriptionToUser() async {
   
    await FirebaseFirestore.instance
    .collection('users')
    .get()
    .then((qshot) {
      qshot.docs.forEach((DocumentSnapshot doc) async {
        await FirebaseFirestore.instance
        .collection('users')
        .doc(doc.id)
        .update({
          'description': "",
        });
      });
    });
    
  }
}