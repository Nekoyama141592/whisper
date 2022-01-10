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
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
import 'package:whisper/domain/many_update_post/many_update_post.dart';
import 'package:whisper/domain/whisper_user_meta/whisper_user_meta.dart';
import 'package:whisper/domain/whisper_many_update_user/whisper_many_update_user.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'package:whisper/main_model.dart';

Future<File?> returnCroppedFile ({ required XFile? xFile }) async {
  final File? result = await ImageCropper.cropImage(
    sourcePath: xFile!.path,
    aspectRatioPresets: Platform.isAndroid ? [ CropAspectRatioPreset.square ] : [ CropAspectRatioPreset.square ],
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

Reference userImageParentRef({ required String uid }) {
  return FirebaseStorage.instance.ref().child(userImagesKey).child(uid);
}

Reference userImageChildRef({ required String uid, required String storageImageName }) {
  final parentRef = userImageParentRef(uid: uid);
  return parentRef.child(storageImageName);
}

Reference postImageParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postImagesKey).child(mainModel.currentUser!.uid);
}

Reference postImageChildRef({ required MainModel mainModel, required String postImageName }) {
  final parentRef = postImageParentRef(mainModel: mainModel);
  return parentRef.child(postImageName);
}

Reference postParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postsKey).child(mainModel.currentWhisperUser.uid);
}

Reference postChildRef({ required MainModel mainModel, required String storagePostName }) {
  final parentRef = postParentRef(mainModel: mainModel);
  return parentRef.child(storagePostName);
}

final CollectionReference<Map<String, dynamic>> postColRef = FirebaseFirestore.instance.collection(postsKey);

CollectionReference<Map<String, dynamic>> followersParentRef({ required String passiveUid }) {
  return FirebaseFirestore.instance.collection(usersKey).doc(passiveUid).collection(followersKey);
}

DocumentReference<Map<String, dynamic>> followerChildRef({ required String passiveUid , required String followerUid}) {
  final parentRef = followersParentRef(passiveUid: passiveUid);
  return parentRef.doc(followerUid);
}

CollectionReference<Map<String, dynamic>> likesParentRef({ required String parentColKey ,required String uniqueId }) {
  return FirebaseFirestore.instance.collection(parentColKey).doc(uniqueId).collection(likesKey);
}

DocumentReference<Map<String, dynamic>> likeChildRef({ required String parentColKey,  required String uniqueId, required String activeUid}) {
  final parentRef =likesParentRef(parentColKey: parentColKey, uniqueId: uniqueId);
  return parentRef.doc(activeUid);
}

CollectionReference<Map<String, dynamic>> bookmarkParentRef({required String postId }) {
  return FirebaseFirestore.instance.collection(postsKey).doc(postId).collection(bookmarksKey);
}

DocumentReference<Map<String, dynamic>> bookmarkChildRef({required String postId, required String activeUid}) {
  final parentRef =bookmarkParentRef(postId: postId);
  return parentRef.doc(activeUid);
}

DocumentReference<Map<String, dynamic>> commentNotificationRef({ required String passiveUid , required String notificationId}) {
  return FirebaseFirestore.instance.collection(userMetaKey).doc(passiveUid).collection(commentNotificationsKey).doc(notificationId);
}

DocumentReference<Map<String, dynamic>> replyNotificationRef({ required String passiveUid , required String notificationId}) {
  return FirebaseFirestore.instance.collection(userMetaKey).doc(passiveUid).collection(replyNotificationsKey).doc(notificationId);
}

CollectionReference<Map<String, dynamic>>  commentNotificationsParentRef({ required String uid }) {
  return FirebaseFirestore.instance.collection(usersKey).doc(uid).collection(commentNotificationsKey);
}

CollectionReference<Map<String, dynamic>>  replyNotificationsParentRef({ required String uid }) {
  return FirebaseFirestore.instance.collection(usersKey).doc(uid).collection(replyNotificationsKey);
}

WhisperUser fromMapToWhisperUser({ required Map<String,dynamic> userMap }) {
  return WhisperUser.fromJson(userMap);
}
WhisperComment fromMapToWhisperComment({ required Map<String,dynamic> commentMap }) {
  return WhisperComment.fromJson(commentMap);
}
ManyUpdatePost fromMapToManyUpdatePost({ required Map<String,dynamic> manyUpdatePostMap }) {
  return ManyUpdatePost.fromJson(manyUpdatePostMap);
}
Post fromMapToPost({ required Map<String,dynamic> postMap }) {
  return Post.fromJson(postMap);
}
WhisperReply fromMapToWhisperReply({ required Map<String,dynamic> replyMap }) {
  return WhisperReply.fromJson(replyMap);
}
WhisperManyUpdateUser fromMapToManyUpdateUser({ required Map<String,dynamic> manyUpdateUserMap }) {
  return WhisperManyUpdateUser.fromJson(manyUpdateUserMap);
}
WhisperUserMeta fromMapToWhisperUserMeta({ required Map<String,dynamic> userMetaMap }) {
  return WhisperUserMeta.fromJson(userMetaMap);
}