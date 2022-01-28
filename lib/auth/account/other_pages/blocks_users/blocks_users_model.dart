// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/block_user/block_user.dart';
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
    final List<BlockUser> blockUsers = await returnBlockUserTokens(myUid: firebaseAuthCurrentUser!.uid);
    List<String> blocksUids = blockUsers.map((e) => e.uid).toList();
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
      await FirebaseFirestore.instance.collection(usersFieldKey).where(uidFieldKey,whereIn: blocksUids).get().then((qshot) {
        blocksUserDocs = qshot.docs;
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
    getAnddeleteToken;
  }


}