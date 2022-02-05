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
    muteUids = muteUsers.map((muteUser) => muteUser.passiveUid).toList();
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

  Future<void> unMuteUser({ required String passiveUid, required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    final deleteMuteUserToken = mainModel.muteUsers.where((element) => element.passiveUid == passiveUid ).toList().first;
    // front mute_users_model
    muteUids.remove(passiveUid);
    userDocs.removeWhere((element) => element.id == passiveUid );
    // front main_model
    mainModel.muteUids.remove(passiveUid);
    mainModel.muteUsers.remove(deleteMuteUserToken);
    notifyListeners();
    // back
    await returnTokenDocRef(uid: currentWhisperUser.uid,tokenId: deleteMuteUserToken.tokenId).delete();
  }

}