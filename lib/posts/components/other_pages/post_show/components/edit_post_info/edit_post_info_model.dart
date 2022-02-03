// dart  
import 'dart:io';
// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/links/links_model.dart';
import 'package:whisper/main_model.dart';
// domain
import 'package:whisper/domain/post/post.dart';

final editPostInfoProvider = ChangeNotifierProvider(
  (ref) => EditPostInfoModel()
);

class EditPostInfoModel extends ChangeNotifier {
  
  bool isEditing = false;
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

  Future<String> uploadImage({ required MainModel mainModel,required String postId }) async {
    final thisPostImageName = returnStoragePostImageName();
    final ref = returnPostImageChildRef(mainModel: mainModel,postImageName: thisPostImageName,postId: postId);
    await ref.putFile(croppedFile!);
    final String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future updatePostInfo({ required Post whisperPost , required MainModel mainModel, required BuildContext context,required LinksModel linksModel }) async {
    final String imageURL = croppedFile == null ? whisperPost.imageURLs.first : await uploadImage(mainModel: mainModel,postId: whisperPost.postId );
    try{
      whisperPost.imageURLs = [imageURL];
      whisperPost.updatedAt = Timestamp.now();
      whisperPost.links = linksModel.whisperLinks.map((e) => e.toJson() ).toList();
      await returnPostDocRef(postCreatorUid: whisperPost.uid, postId: whisperPost.postId ).update(whisperPost.toJson());
      isEditing = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('データが更新されました！表示に反映されなければ、タブをきってください')));
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('なんらかのエラーが発生しました')));
    }
  }
  
}