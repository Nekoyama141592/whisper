// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/counts.dart';
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/others.dart' as others;
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/routes.dart' as routes;
import 'package:whisper/constants/strings.dart' as strings;

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
  DateTime birthDay = DateTime(1900,10,10);
  final displayBirthDayNotifier = ValueNotifier<DateTime>(DateTime(1900,10,10));
  String language = '';
  final displayLanguageNotifier = ValueNotifier<String>('');
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

  Future showImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await others.returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCropped = true;
    }
    notifyListeners();
  }

  Future signup(BuildContext context) async {
    if (commonPasswords.contains(password)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ありふれたパスワードです。変更してください')));
    } else if (userName.length >= 64) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ユーザー名は64文字以内にしてください')));
    }else {
      try{
        UserCredential result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );
        User? user = result.user;
        await addUserToFireStore(user!.uid);
        routes.toVerifyPage(context);
      } on FirebaseAuthException catch(e) {
        print(e.code);
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('パスワードが弱いです')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('そのメールアドレスはすでに使われています')));
        } else {
          print(e.toString());
        }
      }
    }
  }
  
  Future addUserToFireStore(uid) async {
    final timestampBirthDay = Timestamp.fromDate(birthDay);
    final String storageImageName = strings.storageUserImageName;
    final String imageURL = await voids.uploadUserImageAndGetURL(uid: uid, croppedFile: croppedFile,storageImageName: storageImageName );
    await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
      'authNotifications': [],
      'birthDay': timestampBirthDay,
      'browsingHistory': [],
      'blocksIpv6AndUids': [],
      'bookmarks': [],
      'commentNotifications': [],
      'createdAt': Timestamp.now(),
      'description': '',
      'dmState': 'onlyFollowingAndFollowed',
      'followNotifications': [],
      'followersCount': 0,
      'followingUids': [],
      'gender': gender,
      'imageURL': imageURL,
      'isAdmin': false,
      'isDelete': false,
      'isKeyAccount': false,
      'isNFTicon': false,
      'isOfficial': false,
      'isSubAdmin': false,
      'language': language,
      'likedComments': [],
      'likeNotifications': [],
      'likedReplys': [],
      'likes': [],
      'link': '',
      'mutesIpv6AndUids': [],
      'noDisplayWords': [],
      'otherLinks': [],
      'readNotificationIds': [],
      'readPosts': [],
      'recommendState': 'recommendable',
      'replyNotifications': [],
      'score': defaultScore,
      'searchHistory': [],
      'storageImageName': storageImageName, // use on lib/auth/account/account_model.dart
      'subUserName': uid, // use on lib/components/add_post/add_post_model.dart, lib/posts/components/replys/replys_model.dart, lib/posts/components/comments/comments_model.dart
      'uid' : uid,
      'updatedAt': Timestamp.now(),
      'userName': userName,
      'walletAddress': '',
    });
  }

  void showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context, 
      builder: (context) {
        final now = DateTime.now();
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          child: CupertinoDatePicker(
            backgroundColor: Theme.of(context).focusColor,
            initialDateTime: DateTime(now.year - 18,12,31),
            minimumDate: DateTime(1900,12,31),
            maximumDate: DateTime(now.year - 6,12,31),
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value){
              birthDay = value;
              displayBirthDayNotifier.value = value;
            }
          ),
        );
      }
    );
  }

  void showLanguageCupertinoActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context, 
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                '日本語',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                language = 'ja';
                displayLanguageNotifier.value = '日本語';
                Navigator.pop(context);
              }, 
            ),
            CupertinoActionSheetAction(
              child: Text(
                'English',
                style: TextStyle(
                  color: Theme.of(context).highlightColor,
                  fontWeight: FontWeight.bold
                ),
              ),
              onPressed: () {
                language = 'en';
                displayLanguageNotifier.value = '英語';
                Navigator.pop(context);
              }, 
            ),
          ],
        );
      }
    );
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
                gender = 'male';
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
                gender = 'female';
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
                gender = 'others';
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
                gender = 'noAnswer';
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