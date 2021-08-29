import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final addPostProvider = ChangeNotifierProvider(
  (ref) => AddPostModel()
);

class AddPostModel extends ChangeNotifier {
  String postTitle = "";
  bool isLoading = false;
  User? currentUser;
  late QuerySnapshot<Map<String, dynamic>> userDocument;
  
  AddPostModel() {
    init();
  }

  void init() {
    setCurrentUser();
  }

  startLoading() {
    isLoading = true;
    notifyListeners();
  }

  endLoading() {
    isLoading = false;
    notifyListeners();
  }
  
  void addButtonPressed(context) async {
    startLoading();
    await addPostToFirebase(context);
    endLoading();
  }

  Future addPostToFirebase(context) async {
    if (postTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('postTitle is Empty'))
      );
    } else {
      try {
        await FirebaseFirestore.instance.collection('posts')
        .add({
          'imageURL': '',
          'ImageExist': false,
          'audioURL': '',
          'uid': currentUser!.uid,
          'createdAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
          'score': 0,
          'likes': 0,
          'preservations': 0,
        });
      } catch(e) {
        print(e.toString());
      }
    }
  }
  Future setCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }
}