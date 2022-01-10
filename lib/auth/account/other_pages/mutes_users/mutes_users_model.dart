// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';

final mutesUsersProvider = ChangeNotifierProvider(
  (ref) => MutesUsersModel()
);

class MutesUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> mutesUserDocs = [];

  MutesUsersModel() {
    init();
  }

  Future init() async {
    startLoading();
    final DocumentSnapshot<Map<String,dynamic>> currentUserDoc = await setCurrentUserDoc();
    final List<dynamic> mutesIpv6AndUids = currentUserDoc[mutesIpv6AndUidsKey];
    List<dynamic> mutesUids = [];
    mutesIpv6AndUids.forEach((mutesIpv6AndUid) {
      mutesUids.add(mutesIpv6AndUid[uidKey]);
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

  Future<DocumentSnapshot<Map<String,dynamic>>> setCurrentUserDoc() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot<Map<String,dynamic>> currentUserDoc = await FirebaseFirestore.instance.collection(usersKey).doc(currentUser!.uid).get();
    return currentUserDoc;
  }

  Future getMutesUserDocs({ required List<dynamic> mutesUids }) async {
    if (mutesUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection(usersKey).where(uidKey,whereIn: mutesUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
          mutesUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future unMuteUser({ required String passiveUid, required List<dynamic> mutesUids, required WhisperUser currentWhisperUser, required List<dynamic> mutesIpv6AndUids}) async {
    // front
    mutesUserDocs.removeWhere((mutesUserDoc) => mutesUserDoc[uidKey] == passiveUid);
    notifyListeners();
    // back
    mutesIpv6AndUids.removeWhere((mutesIpv6AndUid) => mutesIpv6AndUid[uidKey] == passiveUid);
    mutesUids.remove(passiveUid);
    voids.updateMutesIpv6AndUids(mutesIpv6AndUids: mutesIpv6AndUids, currentWhisperUser: currentWhisperUser);
  }

}