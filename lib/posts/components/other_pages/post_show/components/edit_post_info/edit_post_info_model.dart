// dart  
import 'dart:io';
// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/strings.dart';

final editPostInfoProvider = ChangeNotifierProvider(
  (ref) => EditPostInfoModel()
);

class EditPostInfoModel extends ChangeNotifier {
  
  bool isEditing = false;
  String postTitle = '';
  // image
  bool isCropped = false;
  XFile? xfile;
  File? croppedFile;

  void reload() {
    notifyListeners();
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
        toolbarColor: kPrimaryColor,
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
      notifyListeners();
    }
  }

  // Future<String> uploadImage(DocumentSnapshot currentUserDoc) async {
  //   final String imageName = currentUserDoc[uidKey] + DateTime.now().microsecondsSinceEpoch.toString();
  //   try {
  //     await FirebaseStorage.instance
  //     .ref()
  //     .child('postImages')
  //     .child(imageName + '.jpg')
  //     .putFile(croppedFile!);
  //   } catch(e) {
  //     print(e.toString());
  //   }
  //   final String downloadURL = await FirebaseStorage.instance
  //   .ref()
  //   .child('postImages')
  //   .child(imageName + '.jpg')
  //   .getDownloadURL();
  //   return downloadURL;
  // }

  // Future updatePostInfo(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,BuildContext context) async {
  //   final String currentSongDocImageURL = currentSongMap['imageURL'];
  //   final String resultURL = currentSongDocImageURL.isNotEmpty ? currentSongDocImageURL : currentSongMap['userImageURL'];
  //   final String imageURL = croppedFile == null ? resultURL : await uploadImage(currentUserDoc);
    
  //   try{
  //     await FirebaseFirestore.instance
  //     .collection('posts')
  //     .doc(currentSongMap['postId'])
  //     .update({
  //       'title': postTitle,
  //       'imageURL': imageURL,
  //       'updatedAt': Timestamp.now(),
  //     });
  //     isEditing = false;
  //     notifyListeners();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('データが変更されました！'),
  //       duration: Duration(seconds: 3),
  //     ));
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('タブを切ると変更が画面に反映されます')));
  //   } catch(e) {
  //     print(e.toString());
  //   }
  // }
  
}