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

final editPostInfoProvider = ChangeNotifierProvider(
  (ref) => EditPostInfoModel()
);

class EditPostInfoModel extends ChangeNotifier {
  
  bool isEdited = false;
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

  Future<String> uploadImage(String currentUserDocUid) async {
    final String imageName = currentUserDocUid + DateTime.now().microsecondsSinceEpoch.toString();
    try {
      await FirebaseStorage.instance
      .ref()
      .child('postImages')
      .child(imageName + '.jpg')
      .putFile(croppedFile!);
    } catch(e) {
      print(e.toString());
    }
    final String downloadURL = await FirebaseStorage.instance
    .ref()
    .child('postImages')
    .child(imageName + '.jpg')
    .getDownloadURL();
    return downloadURL;
  }

  Future updatePostInfo(currentSongDocId,currentUserDocUid) async {
    // final String imageURL = croppedFile == null ? '' : await uploadImage(currentUserDocUid);
    final String imageURL = '';
    try{
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongDocId)
      .update({
        'title': postTitle,
        'imageURL': imageURL,
      });
    } catch(e) {
      print(e.toString());
    }
  }
  
}