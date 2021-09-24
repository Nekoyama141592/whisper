import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final editProfileProvider = ChangeNotifierProvider((ref) => EditProfileModel());

class EditProfileModel extends ChangeNotifier {
  
  User? currentUser;
  bool isVisible = false;
  String userName = '';
  String description = '';

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  void toggleIsVisible() {
    isVisible = !isVisible;
    notifyListeners();
  }

  Future updateUserInfo(DocumentSnapshot currentUserDoc) async {
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'userName': userName,
      'description': description,
    });
  }
}