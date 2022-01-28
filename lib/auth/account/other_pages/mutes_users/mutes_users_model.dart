// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
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

  Future<void> init() async {
    startLoading();
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

  Future<void> getMutesUserDocs({ required List<dynamic> mutesUids }) async {
    if (mutesUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection(usersKey).where(uidKey,whereIn: mutesUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
          mutesUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future<void> unMuteUser({ required String passiveUid, required List<dynamic> mutesUids, required WhisperUser currentWhisperUser}) async {
    // front
    mutesUserDocs.removeWhere((userDoc) {
      final WhisperUser whisperUser = fromMapToWhisperUser(userMap: userDoc.data()!);
      return whisperUser.uid == passiveUid;
    });
    mutesUids.remove(passiveUid);
    notifyListeners();
    // back
    voids.updateMutesIpv6AndUids(mutesIpv6AndUids: muteUsers, currentWhisperUser: currentWhisperUser);
  }

}