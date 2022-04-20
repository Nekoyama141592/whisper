// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/maps.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart' as strings;
import 'package:whisper/details/positive_text.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
// domain
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/l10n/l10n.dart';

final signupProvider = ChangeNotifierProvider(
  (ref) => SignupModel()
);

class SignupModel extends ChangeNotifier {
  
  // basic
  bool isLoading = false;
  // info
  String userName = "";
  String email = "";
  String password = "";
  bool isObscure = true;
  String gender = "";
  final displayGenderNotifier = ValueNotifier<String>('');
  // Checkbox
  final isCheckedNotifier = ValueNotifier<bool>(false);
  // image
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void toggleIsObsucure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  void toggleIsChecked() {
    isCheckedNotifier.value = !isCheckedNotifier.value;
  }

  Future<void> showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future<void> cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCropped = true;
    }
    notifyListeners();
  }

  Future<void> signup({ required BuildContext context}) async {
    final L10n l10n = returnL10n(context: context)!;
    if (commonPasswords.contains(password)) {
      voids.showBasicFlutterToast(context: context, msg: l10n.commonPassword );
    } else if (userName.length > maxSearchLength ) {
      voids.maxSearchLengthAlert(context: context,isUserName: true);
    }else {
      try{
        UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,);
        User? user = result.user;
        final String uid = user!.uid;
        final String storageImageName = strings.returnStorageUserImageName();
        final String imageURL = await voids.uploadUserImageAndGetURL(uid: uid, croppedFile: croppedFile,storageImageName: storageImageName );
        await addUserToFireStore(uid: uid, imageURL: imageURL,);
        await createUserMeta(uid: uid);
        routes.toVerifyPage(context);
      } on FirebaseAuthException catch(e) {
        final L10n l10n = returnL10n(context: context)!;
        final String errorCode = e.code;
        switch(errorCode) {
          case 'invalid-email':
          voids.showBasicFlutterToast(context: context, msg: l10n.invalidEmail);
          break;
          case 'user-disabled':
          voids.showBasicFlutterToast(context: context, msg: l10n.userDisabled);
          break;
          case 'user-not-found':
          voids.showBasicFlutterToast(context: context, msg: l10n.authUserNotFound );
          break;
          case 'wrong-password':
          voids.showBasicFlutterToast(context: context, msg: l10n.wrongPassword);
          break;
          case 'too-many-requests':
          voids.showBasicFlutterToast(context: context, msg: l10n.tooManyRequests );
          break;
        }
      }
    }
  }
  
  Future<void> addUserToFireStore({ required String uid, required String imageURL, }) async {
    final List<String> searchWords = returnSearchWords(searchTerm: userName);
    final Timestamp now = Timestamp.now();
    Map<String,dynamic> whisperUserMap = WhisperUser(
      accountName: uid,
      createdAt: now,
      bio: '',
      bioLanguageCode: '',
      bioNegativeScore: initialNegativeScore,
      bioPositiveScore: initialPositiveScore,
      bioSentiment: '',
      blockCount: initialCount,
      dmState: returnDmStateString(dmState: DmState.onlyFollowingAndFollowed),
      followerCount: initialCount,
      followingCount: initialCount,
      isAdmin: false,
      isGovernmentOfficial: false,
      isKeyAccount: false,
      isNFTicon: false,
      isOfficial: false,
      isSuspended: false,
      muteCount: initialCount,
      postCount: initialCount,
      links: [],
      nftIconInfo: {},
      recommendState: returnRecommendStateString(recommendState: RecommendState.isRecommendable ),
      reportCount: initialCount,
      score: defaultScore,
      searchToken: returnSearchToken(searchWords: searchWords),
      totalAsset: initialAsset,
      uid : uid,
      updatedAt: now,
      userImageURL: imageURL,
      userImageNegativeScore: initialNegativeScore,
      userName: userName,
      userNameLanguageCode: '',
      userNameNegativeScore: initialNegativeScore,
      userNamePositiveScore: initialPositiveScore,
      userNameSentiment: '',
      mainWalletAddress: '',
      walletAddresses: [],
      walletConnected: false
    ).toJson();
    await FirebaseFirestore.instance.collection(usersFieldKey).doc(uid).set(whisperUserMap);
  }

  Future<void> createUserMeta({ required String uid }) async {
    final Timestamp now = Timestamp.now();
    final ipv6 =  await Ipify.ipv64();
    final UserMeta userMeta = UserMeta(
      createdAt: now,
      email: email,
      gender: gender,
      ipv6: ipv6,
      totalAsset: initialAsset,
      uid: uid,
      updatedAt: now,
    );
    final String bookmarkPostCategoryId = returnTokenId( userMeta: userMeta, tokenType: TokenType.bookmarkPostCategory );
    final BookmarkPostCategory bookmarkPostCategory = BookmarkPostCategory(uid: uid,categoryName: unNamedString,createdAt: now,updatedAt: now,tokenId: bookmarkPostCategoryId, tokenType: bookmarkPostCategoryTokenType,imageURL: '' );
    await returnUserMetaDocRef(uid: uid).set(userMeta.toJson());
    await returnTokenDocRef(uid: uid, tokenId: bookmarkPostCategoryId ).set(bookmarkPostCategory.toJson());
  }

  void showGenderCupertinoActionSheet({ required BuildContext context}) {
    final L10n l10n = returnL10n(context: context)!;
    showCupertinoModalPopup(
      context: context, 
      builder: (innerContext) {
        final String male = l10n.male;
        final String female = l10n.female;
        final String others = l10n.others;
        final String noAnswer = l10n.noAnswer;
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: PositiveText(text: male ),
              onPressed: () {
                gender = returnGenderString(gender: Gender.male);
                displayGenderNotifier.value = male;
                Navigator.pop(innerContext);
              }, 
            ),
            CupertinoActionSheetAction(
              child: PositiveText(text: female),
              onPressed: () {
                gender = returnGenderString(gender: Gender.female);
                displayGenderNotifier.value = female;
                Navigator.pop(innerContext);
              }, 
            ),
            CupertinoActionSheetAction(
              child: PositiveText(text: others),
              onPressed: () {
                gender = returnGenderString(gender: Gender.others);
                displayGenderNotifier.value = others;
                Navigator.pop(innerContext);
              }, 
            ),
            CupertinoActionSheetAction(
              child: PositiveText(text: noAnswer),
              onPressed: () {
                gender = returnGenderString(gender: Gender.noAnswer);
                displayGenderNotifier.value = noAnswer;
                Navigator.pop(innerContext);
              }, 
            )
          ],
        );
      }
    );
  }

}