// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mutesUsersProvider = ChangeNotifierProvider(
  (ref) => MutesUsersModel()
);

class MutesUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot> mutesUserDocs = [];

  MutesUsersModel() {
    init();
  }

  Future init() async {
    startLoading();
    final DocumentSnapshot currentUserDoc = await setCurrentUserDoc();
    final List<dynamic> mutesIpv6AndUids = currentUserDoc['mutesIpv6AndUids'];
    List<dynamic> mutesUids = [];
    mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
      mutesUids.add(mutesIpv6AndUid['uid']);
    });
    await getMutesUserDocs(mutesUids: mutesUids);
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

  Future<DocumentSnapshot> setCurrentUserDoc() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot currentUserDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
    return currentUserDoc;
  }

  Future getMutesUserDocs({ required List<dynamic> mutesUids }) async {
    if (mutesUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').where('uid',whereIn: mutesUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot doc) {
          mutesUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future unMuteUser({ required String passiveUid, required List<dynamic> mutesUids, required DocumentSnapshot currentUserDoc, required List<dynamic> mutesIpv6AndUids}) async {
    // front
    mutesUserDocs.removeWhere((mutesUserDoc) => mutesUserDoc['uid'] == passiveUid);
    notifyListeners();
    // back
    mutesIpv6AndUids.removeWhere((mutesIpv6AndUid) => mutesIpv6AndUid['uid'] == passiveUid);
    mutesUids.remove(passiveUid);
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
    .update({
      'mutesUids': mutesUids,
      'mutesIpv6AndUids': mutesIpv6AndUids,
    });
  }

}