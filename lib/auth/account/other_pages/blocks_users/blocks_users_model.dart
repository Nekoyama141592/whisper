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

  Future<void> init() async {
    startLoading();
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

  Future<void> getBlocksUserDocs({ required List<dynamic> blocksUids }) async {
    if (blocksUids.isNotEmpty) {
      await FirebaseFirestore.instance.collection(usersKey).where(uidKey,whereIn: blocksUids).get().then((qshot) {
        qshot.docs.forEach((DocumentSnapshot<Map<String,dynamic>> doc) {
          blocksUserDocs.add(doc);
        });
        notifyListeners();
      });
    }
  }

  Future<void> unBlockUser({ required String passiveUid, required List<dynamic> blocksUids, required WhisperUser currentWhisperUser}) async {
    // front
    blocksUserDocs.removeWhere((userDoc) {
      final WhisperUser whisperUser = fromMapToWhisperUser(userMap: userDoc.data()!);
      return whisperUser.uid == passiveUid;
    });
    blocksUids.remove(passiveUid);
    notifyListeners();
    // back
    deleteToken;
  }


}