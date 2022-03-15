// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/ints.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/user_update_log_no_batch/user_update_log_no_batch.dart';
// pages
import 'package:whisper/links/post_links/links_page.dart';

final userLinksProvider = ChangeNotifierProvider(
  (ref) => UserLinksModel()
);
class UserLinksModel extends ChangeNotifier {

  final whisperLinksNotifier = ValueNotifier<List<WhisperLink>>([]);
  void initLinks({ required BuildContext context  ,required WhisperUser currentWhisperUser  }) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage(whisperLinksNotifier: whisperLinksNotifier, onRoundedButtonPressed: () async { updateUserLink(context: context,updateWhisperUser: currentWhisperUser); }, roundedButtonText: '更新' ) ));
    whisperLinksNotifier.value = [];
    whisperLinksNotifier.value = currentWhisperUser.links.map((e) => fromMapToWhisperLink(whisperLink: e) ).toList();
    notifyListeners();
  }

  Future<void> updateUserLink ({ required BuildContext context,required WhisperUser updateWhisperUser }) async {
    if (whisperLinksNotifier.value.length > maxLinksLength) {
      alertMaxLinksLength(context: context);
    } else {
      final UserUpdateLogNoBatch userUpdateLogNoBatch = UserUpdateLogNoBatch(bio: updateWhisperUser.bio,dmState: updateWhisperUser.dmState, isKeyAccount: updateWhisperUser.isKeyAccount, links: updateWhisperUser.links, updatedAt: Timestamp.now(), walletAddresses: updateWhisperUser.walletAddresses);
      await returnUserUpdateLogNoBatchDocRef(uid: updateWhisperUser.uid, userUpdateLogNoBatchId: generateUserUpdateLogNoBatchId() ).set(userUpdateLogNoBatch.toJson());
    }
  }
}