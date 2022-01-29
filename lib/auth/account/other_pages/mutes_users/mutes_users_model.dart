// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/mute_user/mute_user.dart';
// model
import 'package:whisper/main_model.dart';

final mutesUsersProvider = ChangeNotifierProvider(
  (ref) => MutesUsersModel()
);

class MutesUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];
  int lastIndex = 0;
  List<String> muteUids = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<void> init({ required MainModel mainModel }) async {
    startLoading();
    final List<MuteUser> muteUsers = mainModel.muteUsers;
    muteUids = muteUsers.map((muteUser) => muteUser.uid).toList();
    await getMutesUserDocs();
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

  Future<void> onLoading() async {
    await getOldMuteUsers();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getMutesUserDocs() async {
    await processMuteUsers();
  }

  Future<void> getOldMuteUsers() async {
    if (muteUids.length > (lastIndex + tenCount)) {
      await processMuteUsers();
    }
  }

  Future<void> processMuteUsers() async {
    if (muteUids.isNotEmpty) {
      List<String> max10 = muteUids.length > (lastIndex + tenCount) ? muteUids.sublist(0,tenCount) : muteUids.sublist( 0,muteUids.length );
      await FirebaseFirestore.instance.collection(usersFieldKey).where(uidFieldKey,whereIn: max10 ).get().then((qshot) {
        userDocs = qshot.docs;
      });
      lastIndex = userDocs.length;
    }
  }

  Future<void> unMuteUser({ required String passiveUid, required List<dynamic> mutesUids, required WhisperUser currentWhisperUser}) async {
    // front
    userDocs.removeWhere((userDoc) {
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