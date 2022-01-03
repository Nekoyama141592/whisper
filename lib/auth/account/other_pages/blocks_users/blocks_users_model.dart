// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;


final blocksUsersProvider = ChangeNotifierProvider(
  (ref) => BlocksUsersModel()
);

class BlocksUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> blocksUserDocs = [];

  BlocksUsersModel() {
    init();
  }

  Future init() async {
    startLoading();
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = await setCurrentUserDoc();
    final List<dynamic> blocksIpv6AndUids = currentUserDoc[blocksIpv6AndUidsKey];
    List<dynamic> blocksUids = [];
    blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
      blocksUids.add(blocksIpv6AndUid[uidKey]);
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

  Future<DocumentSnapshot<Map<String,dynamic>>> setCurrentUserDoc() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String,dynamic>> currentUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    return currentUserDoc;
  }

  Future getBlocksUserDocs({ required List<dynamic> blocksUids }) async {
    if (blocksUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection(usersKey).where(uidKey,whereIn: blocksUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
          blocksUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future unBlockUser({ required String passiveUid, required List<dynamic> blocksUids, required DocumentSnapshot<Map<String,dynamic>> currentUserDoc, required List<dynamic> blocksIpv6AndUids}) async {
    // front
    blocksUserDocs.removeWhere((blocksUserDoc) => blocksUserDoc[uidKey] == passiveUid);
    notifyListeners();
    // back
    blocksIpv6AndUids.removeWhere((blocksIpv6AndUid) => blocksIpv6AndUid[uidKey] == passiveUid);
    blocksUids.remove(passiveUid);
    voids.updateBlocksIpv6AndUids(blocksIpv6AndUids: blocksIpv6AndUids, currentUserDoc: currentUserDoc);
  }


}