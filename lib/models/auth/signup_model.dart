// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
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
    } else if (userName.isEmpty || !isCheckedNotifier.value) {
      voids.showBasicFlutterToast(context: context, msg: l10n.inputNotCompleted );
    } else {
      try{
        UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password,);
        User? user = result.user;
        final String uid = user!.uid;
        final String storageImageName = strings.returnStorageUserImageName();
        final String imageURL = await voids.uploadUserImageAndGetURL(uid: uid, croppedFile: croppedFile,storageImageName: storageImageName );
        await createUser(uid: uid, imageURL: imageURL,);
        await createUserMeta(uid: uid);
        routes.toVerifyPage(context);
      } on FirebaseAuthException catch(e) {
        final L10n l10n = returnL10n(context: context)!;
        final String errorCode = e.code;
        switch(errorCode) {
          case 'email-already-in-use':
            await voids.showBasicFlutterToast(context: context, msg: l10n.emailAlreadyInUse);
          break;
          case 'invalid-email':
            await voids.showBasicFlutterToast(context: context, msg: l10n.invalidEmail);
          break;
          case 'operation-not-allowed':
            debugPrint(l10n.firebaseAuthEmailOperationNotAllowed);
          break;
          case 'weak-password':
            await voids.showBasicFlutterToast(context: context, msg: l10n.weakPasswordMsg);
          break;
        }
      }
    }
  }
  
  Future<void> createUser({ required String uid, required String imageURL, }) async {
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
    await returnUserDocRef(uid: uid).set(whisperUserMap);
  }

  Future<void> createUserMeta({ required String uid }) async {
    final Timestamp now = Timestamp.now();
    final ipv6 =  await Ipify.ipv64();
    final UserMeta userMeta = UserMeta(
      createdAt: now,
      email: email,
      gender: '',
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

}