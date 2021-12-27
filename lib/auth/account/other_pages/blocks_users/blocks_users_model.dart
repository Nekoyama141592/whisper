// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final blocksUsersProvider = ChangeNotifierProvider(
  (ref) => BlocksUsersModel()
);

class BlocksUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot> blocksUserDocs = [];

  BlocksUsersModel() {
    init();
  }

  Future init() async {
    startLoading();
    final DocumentSnapshot currentUserDoc = await setCurrentUserDoc();
    final List<dynamic> blocksIpv6AndUids = currentUserDoc['blocksIpv6AndUids'];
    List<dynamic> blocksUids = [];
    blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
      blocksUids.add(blocksIpv6AndUid['uid']);
    });
    await getBlocksUserDocs(blocksUids: blocksUids);
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

  Future getBlocksUserDocs({ required List<dynamic> blocksUids }) async {
    if (blocksUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection('users').where('uid',whereIn: blocksUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot doc) {
          blocksUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future unBlockUser({ required String passiveUid, required List<dynamic> blocksUids, required DocumentSnapshot currentUserDoc, required List<dynamic> blocksIpv6AndUids}) async {
    // front
    blocksUserDocs.removeWhere((blocksUserDoc) => blocksUserDoc['uid'] == passiveUid);
    notifyListeners();
    // back
    blocksIpv6AndUids.removeWhere((blocksIpv6AndUid) => blocksIpv6AndUid['uid'] == passiveUid);
    blocksUids.remove(passiveUid);
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
    .update({
      'blocksUids': blocksUids,
      'blocksIpv6AndUids': blocksIpv6AndUids,
    });
  }


}