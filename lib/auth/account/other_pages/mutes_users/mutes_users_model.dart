// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
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
  List<String> muteUids = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // enum
  final BasicDocType basicDocType = BasicDocType.muteUser;

  Future<void> init({ required MainModel mainModel }) async {
    startLoading();
    final List<MuteUser> muteUsers = mainModel.muteUsers;
    muteUids = muteUsers.map((muteUser) => muteUser.passiveUid).toList();
    await processMuteUsers();
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
    await processMuteUsers();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> onReload() async {
    startLoading();
    await processMuteUsers();
    endLoading();
  }

  Future<void> processMuteUsers() async {
    if (muteUids.length > userDocs.length) {
      final bool = (muteUids.length - userDocs.length) > 10;
      final userDocsLength = userDocs.length;
      List<String> max10MuteUids = bool ? muteUids.sublist(userDocsLength,userDocsLength + tenCount) : muteUids.sublist(userDocsLength,muteUids.length);
      final query = returnUsersColRef().where(uidFieldKey,whereIn: max10MuteUids);
      if (max10MuteUids.isNotEmpty) {
        voids.processBasicDocs(basicDocType: basicDocType,query: query, docs: userDocs );
      }
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
    await returnUserMuteDocRef(passiveUid: passiveUid, activeUid: currentWhisperUser.uid ).delete();
  }

}