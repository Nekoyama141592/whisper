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
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/bookmark/bookmark.dart';
import 'package:whisper/domain/nft_owner/nft_owner.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/comment/whisper_comment.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
import 'package:whisper/domain/mutesIpv6AndUid/mutesIpv6AndUid.dart';
import 'package:whisper/domain/blocksIpv6AndUid/blocksIpv6AndUid.dart';
import 'package:whisper/domain/official_adsense/official_adsense.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
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
CollectionReference<Map<String,dynamic>> bookmarkLabelParentRef({ required String uid }) {
  return FirebaseFirestore.instance.collection(userMetaKey).doc(uid).collection(bookmarkLabelsString);
}
DocumentReference<Map<String, dynamic>> bookmarkLabelRef({ required String uid, required String bookmarkLabelId }) {
  return bookmarkLabelParentRef(uid: uid).doc(bookmarkLabelId);
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
Post fromMapToPost({ required Map<String,dynamic> postMap }) {
  return Post.fromJson(postMap);
}
WhisperReply fromMapToWhisperReply({ required Map<String,dynamic> replyMap }) {
  return WhisperReply.fromJson(replyMap);
}
UserMeta fromMapToUserMeta({ required Map<String,dynamic> userMetaMap }) {
  return UserMeta.fromJson(userMetaMap);
}

ReplyNotification fromMapToReplyNotification({ required Map<String,dynamic> notificationMap }) {
  return ReplyNotification.fromJson(notificationMap);
}

CommentNotification fromMapToCommentNotification({ required Map<String,dynamic> notificationmap }) {
  return CommentNotification.fromJson(notificationmap);
}

NFTOwner fromMapToNFTOwner({ required Map<String,dynamic> nftOwner }) {
  return NFTOwner.fromJson(nftOwner);
}

OfficialAdsense fromMapToOfficialAdsense({ required Map<String,dynamic> officialAdsenseMap }) {
  return OfficialAdsense.fromJson(officialAdsenseMap);
}

WhisperLink fromMapToWhisperLink({ required Map<String,dynamic> whisperLink }) {
  return WhisperLink.fromJson(whisperLink);
}

BookmarkLabel fromMapToBookmarkLable({ required Map<String,dynamic> map }) {
  return BookmarkLabel.fromJson(map);
}
Bookmark fromMapToBookmark({ required Map<String,dynamic> map }) {
  return Bookmark.fromJson(map);
}
MutesIpv6AndUid fromMapToMutesIpv6AndUid({ required Map<String,dynamic> map }) {
  return MutesIpv6AndUid.fromJson(map);
}
BlocksIpv6AndUid fromMapToBlocksIpv6AndUid({ required Map<String,dynamic> map }) {
  return BlocksIpv6AndUid.fromJson(map);
}

Query<Map<String,dynamic>> returnSearchQuery({ required String collectionKey ,required List<String> searchWords }) {
  Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection(collectionKey).limit(oneTimeReadCount);
  searchWords.forEach((word) {
    query = query.where(tokenToSearchKey + '.' + word,isEqualTo: true);
  });
  return query;
}