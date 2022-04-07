// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/mute_user/mute_user.dart';
// model 
import 'package:whisper/main_model.dart';

final commentsOrReplysProvider = ChangeNotifierProvider(
  (ref) => CommentsOrReplysModel()
);

class CommentsOrReplysModel extends ChangeNotifier {
  
  Future<void> muteUser({ required BuildContext context,required MainModel mainModel, required String passiveUid,}) async {
    if (mainModel.muteUids.contains(passiveUid) == false) {
      // process set
      final Timestamp now = Timestamp.now();
      final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.muteUser );
      final MuteUser muteUser = MuteUser(activeUid:mainModel.userMeta.uid, passiveUid: passiveUid, createdAt: now,tokenId: tokenId, tokenType: muteUserTokenType );
      // processUI
      mainModel.muteUsers.add(muteUser);
      mainModel.muteUids.add(muteUser.passiveUid);
      notifyListeners();
      await showBasicFlutterToast(context: context,msg: muteUserMsg);
      // process backend
      await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(muteUser.toJson());
    } else {
      notifyListeners();
    }
  }

  // Future<void> blockUser({ required BuildContext context,required MainModel mainModel, required String passiveUid,}) async {
  //   if (mainModel.blockUids.contains(passiveUid) == false) {
  //     // process set
  //     final Timestamp now = Timestamp.now();
  //     final String tokenId = returnTokenId( userMeta: mainModel.userMeta, tokenType: TokenType.blockUser );
  //     final BlockUser blockUser = BlockUser(createdAt: now, activeUid: mainModel.userMeta.uid,passiveUid: passiveUid,tokenId: tokenId,tokenType: blockUserTokenType );
  //     // process UI
  //     mainModel.blockUsers.add(blockUser);
  //     mainModel.blockUids.add(blockUser.passiveUid);
  //     showSnackBar(context: context, text: blockUserMsg ); // notifyListeners() not working
  //     // process Backend
  //     await returnTokenDocRef(uid: mainModel.userMeta.uid, tokenId: tokenId).set(blockUser.toJson());
  //   } else {
  //     notifyListeners();
  //   }
  // }

}
