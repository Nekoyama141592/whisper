// dart
import 'dart:async';
import 'dart:io';
// material
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;

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
  XFile? xfile;
  File? croppedFile;
  String downloadURL = '';

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
    xfile = await _picker.pickImage(source: ImageSource.gallery);
    if (xfile != null) {
      await cropImage();
    }
    notifyListeners();
  }

  Future cropImage() async {
    isCropped = false;
    croppedFile = null;
    croppedFile = await ImageCropper.cropImage(
      sourcePath: xfile!.path,
      aspectRatioPresets: Platform.isAndroid ?
      [
        CropAspectRatioPreset.square,
      ]
      : [
        // CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: const AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: kTertiaryColor,
        toolbarWidgetColor: Colors.white,
        // initAspectRatio: CropAspectRatioPreset.original,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: false
      ),
      iosUiSettings: const IOSUiSettings(
        title: 'Cropper',
      )
    );
    if (croppedFile != null) {
      isCropped = true;
    }
    notifyListeners();
  }

  Future uploadImage() async {
    final String dateTime = DateTime.now().microsecondsSinceEpoch.toString();
    if (userName.isEmpty) {
      print('userNameを入力してください');
    }
    try {
      await FirebaseStorage.instance
      .ref()
      .child('users')
      .child('$userName' +'$dateTime' + '.jpg')
      .putFile(croppedFile!);
      downloadURL = await FirebaseStorage.instance
      .ref()
      .child('users')
      .child('$userName' +'$dateTime' + '.jpg')
      .getDownloadURL();
    } catch(e) {
      print(e.toString());
    }
    return downloadURL;
  }

  Future signup(BuildContext context) async {
    try{
      UserCredential result = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
        email: email, 
        password: password,
      );
      User? user = result.user;
      addUserToFireStore(user!.uid);
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
  
  Future addUserToFireStore(uid) async {
    final timestampBirthDay = Timestamp.fromDate(birthDay);
    final imageURL = await uploadImage();
    await FirebaseFirestore.instance
    .collection('users')
    .doc(uid)
    .set({
      'birthDay': timestampBirthDay,
      'blockingUids': [],
      'bookmarks': [],
      'commentNotifications': [],
      'createdAt': Timestamp.now(),
      'description': '',
      'dmState': 'onlyFollowingAndFollowed',
      'followNotifications': [],
      'followersCount': 0,
      'followerUids': [],
      'followingUids': [],
      'gender': gender,
      'imageURL': imageURL,
      'isAdmin': false,
      'isKeyAccount': false,
      'isNFTicon': false,
      'isOfficial': false,
      'isSubAdmin': false,
      'subscriptions': [],
      'joiningGroups':[],
      'language': language,
      'likedComments': [],
      'likeNotifications': [],
      'likedReplys': [],
      'likes': [],
      'link': '',
      'mutesReplyIds': [],
      'mutesUids': [],
      'mutesCommentIds': [],
      'mutesIpv6AndUids': [],
      'mutesPostIds': [],
      'noDisplayWordsOfComments': [],
      'noDisplayWordsOfMyPost': [],
      'otherLinks':[],
      'readNotificationIds': [],
      'readPosts': [],
      'recommendState': 'recommendable',
      'replyNotifications': [],
      'score': 100,
      'searchHistorys': [],
      'subUserName': uid,
      'uid' : uid,
      'updatedAt': Timestamp.now(),
      'userName': userName,
      'walletAddress': ''
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