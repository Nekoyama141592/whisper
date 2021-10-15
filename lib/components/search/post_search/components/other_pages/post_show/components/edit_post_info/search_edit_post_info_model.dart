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

final searchEditPostInfoProvider = ChangeNotifierProvider(
  (ref) => SearchEditPostInfoModel()
);

class SearchEditPostInfoModel extends ChangeNotifier {
  
  bool isEditing = false;
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

  Future<String> uploadImage(DocumentSnapshot currentUserDoc) async {
    final String imageName = currentUserDoc['uid'] + DateTime.now().microsecondsSinceEpoch.toString();
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

  Future updatePostInfo(Map<String,dynamic> currentSongMap,DocumentSnapshot currentUserDoc,BuildContext context) async {
    final String currentSongDocImageURL = currentSongMap['imageURL'];
    final String resultURL = currentSongDocImageURL.isNotEmpty ? currentSongDocImageURL : currentSongMap['userImageURL'];
    final String imageURL = croppedFile == null ? resultURL : await uploadImage(currentUserDoc);
    
    try{
      await FirebaseFirestore.instance
      .collection('posts')
      .doc(currentSongMap['objectID'])
      .update({
        'title': postTitle,
        'imageURL': imageURL,
        'updatedAt': Timestamp.now(),
      });
      isEditing = false;
      isEdited = true;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('投稿の情報が変更されました')));
    } catch(e) {
      print(e.toString());
    }
  }
  
}