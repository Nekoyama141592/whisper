// dart  
import 'dart:io';
// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/main_model.dart';

final editPostInfoProvider = ChangeNotifierProvider(
  (ref) => EditPostInfoModel()
);

class EditPostInfoModel extends ChangeNotifier {
  
  bool isEditing = false;
  String postTitle = '';
  // image
  bool isCropped = false;
  XFile? xFile;
  File? croppedFile;

  void reload() {
    notifyListeners();
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
    croppedFile = await returnCroppedFile(xFile: xFile);
    if (croppedFile != null) {
      isCropped = true;
      notifyListeners();
    }
  }

  Future<String> uploadImage({ required MainModel mainModel }) async {
    final thisPostImageName = postImageName;
    final ref = postImageChildRef(mainModel: mainModel,postImageName: thisPostImageName);
    await ref.putFile(croppedFile!);
    final String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future updatePostInfo({ required Map<String,dynamic> currentSongMap , required MainModel mainModel, required BuildContext context }) async {
    final String imageURL = croppedFile == null ? currentSongMap[imageURLKey] : await uploadImage(mainModel: mainModel);
    try{
      await FirebaseFirestore.instance.collection(postsKey).doc(currentSongMap[postIdKey]).update({
        'title': postTitle,
        'imageURL': imageURL,
        'updatedAt': Timestamp.now(),
      });
      isEditing = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('データが更新されました！表示に反映されなければ、タブをきってください')));
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('なんらかのエラーが発生しました')));
    }
  }
  
}