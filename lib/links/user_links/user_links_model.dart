// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage(whisperLinksNotifier: whisperLinksNotifier, onRoundedButtonPressed: () async { updateUserLink(updateWhisperUser: currentWhisperUser); }, roundedButtonText: '更新' ) ));
    whisperLinksNotifier.value = [];
    whisperLinksNotifier.value = currentWhisperUser.links.map((e) => fromMapToWhisperLink(whisperLink: e) ).toList();
    notifyListeners();
  }

  Future<void> updateUserLink ({ required WhisperUser updateWhisperUser }) async {
    final UserUpdateLogNoBatch userUpdateLogNoBatch = UserUpdateLogNoBatch(bio: updateWhisperUser.bio,dmState: updateWhisperUser.dmState, isKeyAccount: updateWhisperUser.isKeyAccount, links: updateWhisperUser.links, updatedAt: updateWhisperUser.updatedAt, walletAddresses: updateWhisperUser.walletAddresses);
    await returnUserUpdateLogNoBatchDocRef(uid: updateWhisperUser.uid, userUpdateLogNoBatchId: generateUserUpdateLogNoBatchId() ).set(userUpdateLogNoBatch.toJson());
  }
}