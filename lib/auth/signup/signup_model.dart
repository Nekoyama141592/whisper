// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:dart_ipify/dart_ipify.dart';
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/nums.dart';
import 'package:whisper/constants/enums.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> signup(BuildContext context) async {
    if (commonPasswords.contains(password)) {
      voids.showSnackBar(context: context, text: 'ありふれたパスワードです。変更してください' );
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
        final String errorCode = e.code;
        switch(errorCode) {
          case 'invalid-email':
          voids.showSnackBar(context: context, text: 'そのemailは相応しくありません');
          break;
          case 'user-disabled':
          voids.showSnackBar(context: context, text: 'そのemailは無効化されています');
          break;
          case 'user-not-found':
          voids.showSnackBar(context: context, text: 'そのemailに対するユーザーが見つかりません' );
          break;
          case 'wrong-password':
          voids.showSnackBar(context: context, text: 'passwordが違います');
          break;
          case 'too-many-requests':
          voids.showSnackBar(context: context, text: 'ログインの試行回数が制限を超えました' );
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
      bioNegativeScore: 0,
      bioPositiveScore: 0,
      bioSentiment: '',
      blockCount: 0,
      dmState: returnDmStateString(dmState: DmState.onlyFollowingAndFollowed),
      followerCount: 0,
      followingCount: 0,
      userImageURL: imageURL,
      isAdmin: false,
      isGovernmentOfficial: false,
      isKeyAccount: false,
      isNFTicon: false,
      isOfficial: false,
      isSuspended: false,
      muteCount: 0,
      postCount: 0,
      links: [],
      nftIconInfo: {},
      recommendState: returnRecommendStateString(recommendState: RecommendState.isRecommendable ),
      reportCount: 0,
      score: defaultScore,
      searchToken: returnSearchToken(searchWords: searchWords),
      totalAsset: 0,
      uid : uid,
      updatedAt: now,
      userName: userName,
      userNameLanguageCode: '',
      userNameNegativeScore: 0,
      userNamePositiveScore: 0,
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
      totalAsset: 0,
      uid: uid,
      updatedAt: now,
    );
    final String bookmarkPostCategoryId = returnTokenId( userMeta: userMeta, tokenType: TokenType.bookmarkPostCategory );
    final BookmarkPostCategory bookmarkPostCategory = BookmarkPostCategory(uid: uid,categoryName: unNamedString,createdAt: now,updatedAt: now,tokenId: bookmarkPostCategoryId, tokenType: bookmarkPostCategoryTokenType,imageURL: '' );
    await FirebaseFirestore.instance.collection(userMetaFieldKey).doc(uid).set(userMeta.toJson());
    await returnTokenDocRef(uid: uid, tokenId: bookmarkPostCategoryId ).set(bookmarkPostCategory.toJson());
  }

  void showGenderCupertinoActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                '男性',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                gender = returnGenderString(gender: Gender.male);
                displayGenderNotifier.value = '男性';
                Navigator.pop(context);
              }, 
            ),
            CupertinoActionSheetAction(
              child: Text(
                '女性',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                gender = returnGenderString(gender: Gender.female);
                displayGenderNotifier.value = '女性';
                Navigator.pop(context);
              }, 
            ),
            CupertinoActionSheetAction(
              child: Text(
                'その他',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                gender = returnGenderString(gender: Gender.others);
                displayGenderNotifier.value = 'その他';
                Navigator.pop(context);
              }, 
            ),
            CupertinoActionSheetAction(
              child: Text(
                '無回答',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                gender = returnGenderString(gender: Gender.noAnswer);
                displayGenderNotifier.value = '無回答';
                Navigator.pop(context);
              }, 
            )
          ],
        );
      }
    );
  }

}