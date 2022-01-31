// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/ints.dart';
// domain
import 'package:whisper/domain/block_user/block_user.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'package:whisper/main_model.dart';

final blocksUsersProvider = ChangeNotifierProvider(
  (ref) => BlocksUsersModel()
);

class BlocksUsersModel extends ChangeNotifier {

  // basic
  bool isLoading = false;
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];
  int lastIndex = 0;
  List<String> blockUids = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);

  Future<void> init({ required MainModel mainModel }) async {
    startLoading();
    final List<BlockUser> blockUsers = mainModel.blockUsers;
    blockUids = blockUsers.map((e) => e.uid ).toList();
    await getBlocksUserDocs();
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

  Future<void> getBlocksUserDocs() async {
    await processBlockUsers();
  }

  Future<void> onLoading() async {
    await getOldBlockUsers();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> getOldBlockUsers() async {
    if (blockUids.length > (lastIndex + tenCount)) {
      await processBlockUsers();
    }
  }

  Future<void> processBlockUsers() async {
    if (blockUids.isNotEmpty) {
      List<String> max10 = blockUids.length > (lastIndex + tenCount) ? blockUids.sublist(0,tenCount) : blockUids.sublist( 0,blockUids.length );
      await FirebaseFirestore.instance.collection(usersFieldKey).where(uidFieldKey,whereIn: max10 ).get().then((qshot) {
        userDocs = qshot.docs;
      });
      lastIndex = userDocs.length;
    }
  }

  Future<void> unBlockUser({ required String passiveUid, required MainModel mainModel }) async {
    final currentWhisperUser = mainModel.currentWhisperUser;
    // front
    userDocs.removeWhere((userDoc) {
      final WhisperUser whisperUser = fromMapToWhisperUser(userMap: userDoc.data()!);
      return whisperUser.uid == passiveUid;
    });
    mainModel.blockUids.remove(passiveUid);
    blockUids.remove(passiveUid);
    notifyListeners();
    // back
    final deleteBlockToken = mainModel.blockUsers.where((element) => element.uid == passiveUid).toList().first;
    await tokenDocRef(uid: currentWhisperUser.uid, tokenId: deleteBlockToken.tokenId ).delete();
  }


}