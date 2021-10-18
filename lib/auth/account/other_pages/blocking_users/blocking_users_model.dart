// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blockingUsersProvider = ChangeNotifierProvider(
  (ref) => BlockingUsersModel()
);

class BlockingUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  // user
  User? currentUser;
  late DocumentSnapshot currentUserDoc;
  List<DocumentSnapshot> blockingUserDocs = [];

  Future init() async {
    startLoading();
    setCurrentUser();
    await setCurrentUserDoc();
    await setBlockingUserDocs();
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

  void setCurrentUser() {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  Future setCurrentUserDoc() async {
    try{
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid',isEqualTo: currentUser!.uid)
      .limit(1)
      .get()
      .then((qshot) {
        currentUserDoc = qshot.docs[0];
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future setBlockingUserDocs() async {
    final List<dynamic> blockingUids = currentUserDoc['blockingUids'];
    if (blockingUids.isNotEmpty) {
      await FirebaseFirestore.instance
      .collection('users')
      .where('uid',whereIn: blockingUids)
      .get()
      .then((qshot) {
        qshot.docs.forEach((DocumentSnapshot doc) {
          blockingUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future unBlockUser(String passiveUid,List<dynamic> blockingUids,DocumentSnapshot currentUserDoc) async {
    blockingUserDocs.removeWhere((blockingUserDoc) => blockingUserDoc['uid'] == passiveUid);
    notifyListeners();
    blockingUids.remove(passiveUid);
    await FirebaseFirestore.instance
    .collection('users')
    .doc(currentUserDoc.id)
    .update({
      'blockingUids': blockingUids,
    });
  }


}