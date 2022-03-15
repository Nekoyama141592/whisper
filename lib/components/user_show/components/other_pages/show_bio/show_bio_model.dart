// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/user_update_log_no_batch/user_update_log_no_batch.dart';

final showBioProvider = ChangeNotifierProvider(
  (ref) => ShowBioModel()
);

class ShowBioModel extends ChangeNotifier {

  String bio = '';
  Future<void> updateBio({ required BuildContext context, required WhisperUser updateWhisperUser }) async {
    if (bio.isEmpty) {
      voids.showSnackBar(context: context, text: '0文字以上にしてください' );
    } else if (bio.length > maxBioOrDescriptionLength) {
      voids.alertMaxBioLength(context: context);
    } else {
      updateWhisperUser.bio = bio;
      voids.showSnackBar(context: context, text: '更新しました!!!');
      await Future.delayed(Duration(milliseconds: 1000));
      Navigator.pop(context);
      final UserUpdateLogNoBatch userUpdateLogNoBatch = UserUpdateLogNoBatch(bio: updateWhisperUser.bio,dmState: updateWhisperUser.dmState, isKeyAccount: updateWhisperUser.isKeyAccount, links: updateWhisperUser.links, updatedAt: Timestamp.now(), uid: updateWhisperUser.uid,walletAddresses: updateWhisperUser.walletAddresses);
      await returnUserUpdateLogNoBatchDocRef(uid: updateWhisperUser.uid, userUpdateLogNoBatchId: generateUserUpdateLogNoBatchId() ).set(userUpdateLogNoBatch.toJson());
    }
  }
}