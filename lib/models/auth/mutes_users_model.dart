// material
import 'package:flutter/cupertino.dart';
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
import 'package:whisper/constants/widgets.dart';
// domain
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';

final muteUsersProvider = ChangeNotifierProvider(
  (ref) => MuteUsersModel()
);

class MuteUsersModel extends ChangeNotifier {

  // basic
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];
  List<String> muteUids = [];
  // refresh
  RefreshController refreshController = RefreshController(initialRefresh: false);
  // enum
  final BasicDocType basicDocType = BasicDocType.muteUser;
  // query
  Query<Map<String,dynamic>> returnQuery({required List<String> max10MuteUids}) {
    return returnUsersColRef().where(uidFieldKey,whereIn: max10MuteUids).orderBy(createdAtFieldKey,descending: true);
  }

  Future<void> init({ required MainModel mainModel }) async {
    final List<MuteUser> muteUsers = mainModel.muteUsers;
    muteUids = muteUsers.map((muteUser) => muteUser.passiveUid).toList();
    await processMuteUsers();
  }

  Future<void> onRefresh({required MainModel mainModel}) async {
    refreshController.refreshCompleted();
    await processNewMuteUsers(mainModel: mainModel);
    notifyListeners();
  }

  Future<void> onLoading() async {
    await processMuteUsers();
    refreshController.loadComplete();
    notifyListeners();
  }

  Future<void> onReload() async {
    await processMuteUsers();
    notifyListeners();
  }

  Future<void> processMuteUsers() async {
    if (muteUids.length > userDocs.length) {
      final bool = (muteUids.length - userDocs.length) > 10;
      final userDocsLength = userDocs.length;
      List<String> max10MuteUids = bool ? muteUids.sublist(userDocsLength,userDocsLength + tenCount) : muteUids.sublist(userDocsLength,muteUids.length);
      final query = returnQuery(max10MuteUids: max10MuteUids);
      if (max10MuteUids.isNotEmpty) {
        voids.processBasicDocs(basicDocType: basicDocType,query: query, docs: userDocs );
      }
    }
  }

  Future<void> processNewMuteUsers({required MainModel mainModel}) async {
    final newMuteUserTokens = mainModel.newMuteUserTokens;
    // newMuteUidsがprocess()でのmuteUidsにあたり、usedMuteUidsがmuteUserDocsにあたる
    final List<String> newMuteUids = newMuteUserTokens.map((e) => e.passiveUid).toList();
    // 新しくミュートしたのが10人以上の場合
    final List<String> max10MuteUids = newMuteUids.length > 10 ?
    newMuteUids.sublist(0,tenCount) // 10より大きかったら10だけ取り出す
    : newMuteUids;                  // 10より小さかったらそのまま使用
    if (max10MuteUids.isNotEmpty) {
      final qshot = await returnQuery(max10MuteUids: max10MuteUids).get();
      final reversed = qshot.docs.reversed.toList();
      for (final muteUserDoc in reversed) {
        userDocs.insert(0, muteUserDoc);
        // muteUserDocsに加えたということは、もう新しくない。新しいやつから省く。
        final deleteNewMuteUserToken = mainModel.newMuteUserTokens.where((element) => element.passiveUid == muteUserDoc.id).toList().first;
        mainModel.newMuteUserTokens.remove(deleteNewMuteUserToken);// 使用した分を削除 
      }
    }
    notifyListeners();
  }

  void unMuteUser({ required BuildContext context,required String passiveUid, required MainModel mainModel }) {
    voids.showCupertinoDialogue(
      context: context, 
      builder: (innerContext) {
        final L10n l10n = returnL10n(context: context)!;
        return CupertinoAlertDialog(
          title: boldEllipsisText(text: l10n.warning),
          content: boldEllipsisText(text: l10n.unMuteUserMsg),
          actions: [
          CupertinoDialogAction(
            child: Text(cancelText(context: context)),
            onPressed: () => Navigator.pop(innerContext),
          ),
          CupertinoDialogAction(
            child: const Text(okText),
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(innerContext);
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
          ),
        ],
        );
      }
    );
  }

}