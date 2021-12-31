// dart
import 'dart:io';
// material
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
// packages
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
// constants
import 'package:whisper/constants/colors.dart';
// model
import 'package:whisper/main_model.dart';

Future<File?> returnCroppedFile ({ required XFile? xFile }) async {
  final File? result = await ImageCropper.cropImage(
    sourcePath: xFile!.path,
    aspectRatioPresets: Platform.isAndroid ?[ CropAspectRatioPreset.square ] : [ CropAspectRatioPreset.square ],
    androidUiSettings: const AndroidUiSettings(
      toolbarTitle: 'Cropper',
      toolbarColor: kPrimaryColor,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: false
    ),
    iosUiSettings: const IOSUiSettings(
      title: 'Cropper',
    )
  );
  return result;
}

Reference userImageRef({ required String uid, required String storageImageName }) {
  return FirebaseStorage.instance.ref().child('userImages').child(uid).child(storageImageName);;
}

Reference postImageRef({ required MainModel mainModel, required String postImageName }) {
  return FirebaseStorage.instance.ref().child('postImages').child(mainModel.currentUserDoc['uid']).child(postImageName);
}

Reference postRef({ required MainModel mainModel, required String storagePostName }) {
  return FirebaseStorage.instance.ref().child('posts').child(mainModel.currentUserDoc['uid']).child(storagePostName);
}

final CollectionReference<Map<String, dynamic>> postColRef = FirebaseFirestore.instance.collection('posts');