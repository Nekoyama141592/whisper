// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
// packages
import 'package:flash/flash.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/maps.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/widgets.dart';
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/domain/user_update_log/user_update_log.dart';
import 'package:whisper/domain/user_meta_update_log/user_meta_update_log.dart';
import 'package:whisper/l10n/l10n.dart';
// components
import 'package:whisper/details/positive_text.dart';
// models
import 'package:whisper/main_model.dart';

 
Future<void> signOut({required BuildContext context, required BuildContext innerContext }) async {
  await FirebaseAuth.instance.signOut();
  final L10n l10n = returnL10n(context: context)!;
  Navigator.pop(innerContext);
  routes.toIsFinishedPage(context: context, title: l10n.logout, text: l10n.thanksMsg );
}

void showCupertinoDialogue({required BuildContext context, required Widget Function(BuildContext) builder }) {
  showCupertinoDialog(
    context: context, 
    builder: builder
  );
}

Future<void> processNewDocs({ required BasicDocType basicDocType,required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  final qshot = await query.limit(oneTimeReadCount).endBeforeDocument(docs.first).get();
  for (final doc in qshot.docs) {
    if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) {
      docs.insert(0, doc); 
    }
  }
}

Future<void> processBasicDocs({ required BasicDocType basicDocType,required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  // use notifiations and mute users
  final qshot = await query.limit(oneTimeReadCount).get();
  for (final doc in qshot.docs) {
    if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) docs.add(doc);
  }
}

Future<void> processOldDocs({ required BasicDocType basicDocType,required Query<Map<String,dynamic>> query , required List<DocumentSnapshot<Map<String,dynamic>>> docs }) async {
  // use notifiations and mute users
  final qshot = await query.limit(oneTimeReadCount).startAfterDocument(docs.last).get();
  final reversed = qshot.docs.reversed.toList();
  for (final doc in reversed) {
    if (isNotNegativeBasicContent(basicDocType: basicDocType,doc: doc)) docs.add(doc);
  }
}

Future<String> uploadUserImageAndGetURL({ required String uid, required File? croppedFile, required String storageImageName }) async {
  // can`t be given mainModel because of lib/auth/signup/signup_model.dart
  String getDownloadURL = '';
  try {
    final Reference storageRef = returnUserImageChildRef(uid: uid, storageImageName: storageImageName);
    await putImage(imageRef: storageRef, file: croppedFile! );
    getDownloadURL = await storageRef.getDownloadURL();
  } catch(e) { debugPrint(e.toString()); }
  return getDownloadURL;
}

Future<void> updateUserInfo({ required BuildContext context , required WhisperUser updateWhisperUser, required String userName ,required File? croppedFile,required MainModel mainModel }) async {
  // if delete, can`t load old posts. My all post should be updated too.
  // if (croppedFile != null) {
  //   await userImageRef(uid: mainModel.currentUser!.uid, storageImageName: mainModel.currentWhisperUser.storageImageName).delete();
  // }
  if (userName.isNotEmpty) {
    updateWhisperUser.userName = userName;
    updateWhisperUser.searchToken = returnSearchToken(searchWords: returnSearchWords(searchTerm: userName) );
  }
  
  if (croppedFile != null) {
    final String storageImageName = returnStorageUserImageName();
    final String downloadURL = await uploadUserImageAndGetURL(uid: updateWhisperUser.uid, croppedFile: croppedFile, storageImageName: storageImageName );
    updateWhisperUser.userImageURL = downloadURL;
  }
  final Timestamp now = Timestamp.now();
  final UserUpdateLog userUpdateLog = UserUpdateLog(accountName: updateWhisperUser.accountName,userImageURL: updateWhisperUser.userImageURL, mainWalletAddress: updateWhisperUser.mainWalletAddress, recommendState: updateWhisperUser.recommendState, searchToken: updateWhisperUser.searchToken, uid: updateWhisperUser.uid, userName: userName, updatedAt: now );
  await returnUserUpdateLogDocRef(uid: updateWhisperUser.uid, userUpdateLogId: generateUserUpdateLogId() ).set(userUpdateLog.toJson());
}

void showCommentOrReplyDialogue({ required BuildContext context, required String title,required TextEditingController textEditingController, required void Function(String)? onChanged,required void Function()? oncloseButtonPressed ,required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? send }) {
  final L10n l10n = returnL10n(context: context)!;
  context.showFlashBar(
    persistent: true,
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    borderWidth: 3.0,
    behavior: FlashBehavior.fixed,
    forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    title: Text(title,style: TextStyle(fontWeight: FontWeight.bold),),
    content: Form(
      child: TextFormField(
        controller: textEditingController,
        autofocus: true,
        style: TextStyle(fontWeight: FontWeight.bold),
        onChanged: onChanged,
        maxLines: maxLine,
        decoration: InputDecoration(
          suffixIcon: InkWell(onTap: oncloseButtonPressed, child: Icon(Icons.close)),
          hintText: l10n.commentOrReplyLimit(maxCommentOrReplyLength.toString()),
          hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).scaffoldBackgroundColor.withOpacity(cardOpacity))
        ),
      )
    ),
    primaryActionBuilder: send,
    negativeActionBuilder: (context,controller,__) {
      return InkWell(
        child: Icon(Icons.close),
        onTap: () async => await controller.dismiss()
      );
    }
  );
}

void showFlashDialogue({ required BuildContext context,required Widget content, required String titleText ,required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder }) {
  context.showFlashDialog(
    persistent: true,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    title: Text(titleText),
    content: content,
    negativeActionBuilder: (context, controller, _) {
      return TextButton(
        onPressed: () async => await controller.dismiss(),
        child: focusHeaderText(context: context, text: cancelText(context: context))
      );
    },
    positiveActionBuilder: positiveActionBuilder,
  );
}
Future<void> putImage({ required Reference imageRef,required File file }) async => await imageRef.putFile(file,imageMetadata);

Future<void> putPost({ required Reference postRef,required File postFile }) async => await postRef.putFile(postFile,postMetadata);

Future<void> showLinkDialogue({ required BuildContext context, required String link }) async {
  final L10n l10n = returnL10n(context: context)!;
  if ( await canLaunchUrlString(link)) {
    showCupertinoDialog(
      context: context, 
      builder: (innerContext) {
        return CupertinoAlertDialog(
          title: boldEllipsisText(text: l10n.pageTransition),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: link,
                  style: highlightDiv2Style(context: context),
                  recognizer: TapGestureRecognizer()..onTap = () async {
                    final L10n l10n = returnL10n(context: context)!;
                    await FlutterClipboard.copy(link).then((_) {
                      showBasicFlutterToast(context: context, msg: l10n.linkCopied);
                    });
                  },
                ),
              ]
            )
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(cancelText(context: context)),
              onPressed: () => Navigator.pop(innerContext)
            ),
            CupertinoDialogAction(
              child: const Text(okText),
              isDestructiveAction: true,
              onPressed: () async {
                Navigator.pop(innerContext);
                await Future.delayed(Duration(seconds: 1));
                await launchUrlString(link);
              },
            )
          ],
        );
      }
    );
  } else {
    showBasicFlutterToast(context: context, msg: l10n.invalidLink );
  }
}

void showLinkCupertinoModalPopup({ required BuildContext context,required List<WhisperLink> whisperLinks }) {
  showCupertinoModalPopup(
      context: context, 
      builder: (innerContext) {
        final List<Widget> actions = 
        whisperLinks.map((whisperLink) => CupertinoActionSheetAction(
          child: PositiveText(text: whisperLink.label),
          onPressed: () => showLinkDialogue(context: context, link: whisperLink.url )
        ) ).toList();
        actions.add(CupertinoActionSheetAction(
          child: PositiveText(text: cancelText(context: context)),
          onPressed: () => Navigator.pop(innerContext),
        ));
        return CupertinoActionSheet(
          actions: actions
        );
      }
    );  
}

void onAddLinkButtonPressed({ required ValueNotifier<List<WhisperLink>> whisperLinksNotifier }) async {
  final WhisperLink whisperLink = WhisperLink(description: '',imageURL: '',label: '',url: '');
  List<WhisperLink> x = whisperLinksNotifier.value;
  x.add(whisperLink);
  whisperLinksNotifier.value = x.map((e) => e).toList();
}

void onDeleteLinkButtonPressed({ required ValueNotifier<List<WhisperLink>> whisperLinksNotifier,required int i }) {
  List<WhisperLink> x = whisperLinksNotifier.value;
  x.removeAt(i);
  whisperLinksNotifier.value = x.map((e) => e).toList();
}

void maxSearchLengthAlert ({ required BuildContext context,required bool isUserName }) {
  final L10n l10n = returnL10n(context: context)!;
  showBasicFlutterToast(context: context, msg: l10n.userNameLimit(maxSearchLength.toString()));
} 

void alertMaxLinksLength({ required BuildContext context, }) => showBasicFlutterToast(context: context, msg: returnL10n(context: context)!.linkLimit(maxLinksLength.toString()) );

void alertMaxBioLength({ required BuildContext context, }) => showBasicFlutterToast(context: context, msg: returnL10n(context: context)!.bioOrDescriptionLimit(maxBioOrDescriptionLength.toString()) );

void alertMaxCommentOrReplyLength({ required BuildContext context }) => showBasicFlutterToast(context: context, msg: returnL10n(context: context)!.commentOrReplyLimit(maxCommentOrReplyLength.toString()));

Future<void> defaultLaungh({ required BuildContext context,required String url }) async {
  final L10n l10n = returnL10n(context: context)!;
  await canLaunchUrlString(url) ? await launchUrlString(url) : showBasicFlutterToast(context: context, msg: l10n.invalidLink );
}

Future<void> createUserMetaUpdateLog({ required MainModel mainModel}) async {
    final UserMeta userMeta = mainModel.userMeta;
    final ipv6 =  await Ipify.ipv64();
    final currentUser = firebaseAuthCurrentUser();
    final UserMetaUpdateLog userMetaUpdateLog = UserMetaUpdateLog(
      email: currentUser == null ? userMeta.email : currentUser.email! ,
      gender: userMeta.gender, 
      ipv6: ipv6, 
      uid: userMeta.uid, 
      updatedAt: Timestamp.now()
    );
    await returnUserMetaUpdateLogDocRef(uid: userMeta.uid, userMetaUpdateLogId: generateUserMetaUpdateLogId() ).set(userMetaUpdateLog.toJson());
}

Future<void> showBasicFlutterToast({ required BuildContext context,required String msg }) async {
  final backgroundColor = Theme.of(context).highlightColor;
  await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: toastSeconds,
      backgroundColor: backgroundColor,
      textColor: Colors.white
  );
}

Future<void> showCustomFlutterToast({ required Color backgroundColor,required String msg }) async {
  await Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: toastSeconds,
      backgroundColor: backgroundColor,
      textColor: Colors.white
  );
}