// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';

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
    final List<MuteUser> muteUsers = await returnMuteUserTokens(myUid: firebaseAuthCurrentUser!.uid);
    List<String> mutesUids = muteUsers.map((e) => e.uid).toList();
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
      await FirebaseFirestore.instance.collection(usersFieldKey).where(uidFieldKey,whereIn: mutesUids).get().then((qshot) {
        mutesUserDocs = qshot.docs;
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
    final qshot = await tokensParentRef(uid: currentWhisperUser.uid).where(tokenTypeFieldKey,isEqualTo: muteUserTokenType).where(uidFieldKey,isEqualTo: passiveUid).limit(plusOne).get();
    await tokensParentRef(uid: currentWhisperUser.uid).doc(qshot.docs.first.id).delete();
  }

}