// dart
import 'dart:io';
// material
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:whisper/domain/mute_user/mute_user.dart';
import 'package:whisper/domain/block_user/block_user.dart';
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
  return FirebaseStorage.instance.ref().child(userImagesPathKey).child(uid);
}

Reference userImageChildRef({ required String uid, required String storageImageName }) {
  final parentRef = userImageParentRef(uid: uid);
  return parentRef.child(storageImageName);
}

Reference postImageParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postImagesPathKey).child(mainModel.currentUser!.uid);
}

Reference postImageChildRef({ required MainModel mainModel, required String postImageName }) {
  final parentRef = postImageParentRef(mainModel: mainModel);
  return parentRef.child(postImageName);
}

Reference postParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postsFieldKey).child(mainModel.currentWhisperUser.uid);
}

Reference postChildRef({ required MainModel mainModel, required String storagePostName }) {
  final parentRef = postParentRef(mainModel: mainModel);
  return parentRef.child(storagePostName);
}

final CollectionReference<Map<String, dynamic>> postColRef = FirebaseFirestore.instance.collection(postsFieldKey);

CollectionReference<Map<String, dynamic>> followersParentRef({ required String passiveUid }) {
  return FirebaseFirestore.instance.collection(usersFieldKey).doc(passiveUid).collection(followersFieldKey);
}

DocumentReference<Map<String, dynamic>> followerChildRef({ required String passiveUid , required String followerUid}) {
  final parentRef = followersParentRef(passiveUid: passiveUid);
  return parentRef.doc(followerUid);
}

CollectionReference<Map<String, dynamic>> likesParentRef({ required String parentColKey ,required String uniqueId }) {
  return FirebaseFirestore.instance.collection(parentColKey).doc(uniqueId).collection(likesFieldKey);
}

DocumentReference<Map<String, dynamic>> likeChildRef({ required String parentColKey,  required String uniqueId, required String activeUid}) {
  final parentRef =likesParentRef(parentColKey: parentColKey, uniqueId: uniqueId);
  return parentRef.doc(activeUid);
}

CollectionReference<Map<String, dynamic>> bookmarkParentRef({required String postId }) {
  return FirebaseFirestore.instance.collection(postsFieldKey).doc(postId).collection(bookmarksFieldKey);
}

DocumentReference<Map<String, dynamic>> bookmarkChildRef({required String postId, required String activeUid}) {
  final parentRef = bookmarkParentRef(postId: postId);
  return parentRef.doc(activeUid);
}

CollectionReference<Map<String,dynamic>> bookmarkLabelParentRef({ required String uid }) {
  return FirebaseFirestore.instance.collection(userMetaFieldKey).doc(uid).collection(bookmarkLabelsString);
}
DocumentReference<Map<String, dynamic>> bookmarkLabelRef({ required String uid, required String bookmarkLabelId }) {
  return bookmarkLabelParentRef(uid: uid).doc(bookmarkLabelId);
}

CollectionReference<Map<String, dynamic>>  tokensParentRef({ required String uid }) {
  return FirebaseFirestore.instance.collection(userMetaFieldKey).doc(uid).collection(tokensString);
}

DocumentReference<Map<String, dynamic>>  newTokenChildRef({ required String uid , required DateTime now}) {
  return tokensParentRef(uid: uid).doc(returnTokenId(now: now));
}

CollectionReference<Map<String, dynamic>>  notificationParentRef ({ required String uid }) {
  return FirebaseFirestore.instance.collection(userMetaFieldKey).doc(uid).collection(notificationsFieldKey);
}

DocumentReference<Map<String, dynamic>> newNotificationChildRef({ required String uid , required Timestamp now}) {
  return notificationParentRef(uid: uid).doc( returnNotificationId(now: now) );
}

DocumentReference<Map<String,dynamic>> alreadyTokenRef({ required UserMeta userMeta,required String alreadyTokenDocId }) {
  return FirebaseFirestore.instance.collection(userMetaFieldKey).doc(userMeta.uid).collection(tokensString).doc(alreadyTokenDocId);
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

BookmarkLabel fromMapToBookmarkLabel({ required Map<String,dynamic> map }) {
  return BookmarkLabel.fromJson(map);
}
Bookmark fromMapToBookmark({ required Map<String,dynamic> map }) {
  return Bookmark.fromJson(map);
}
MuteUser fromMapToMutesIpv6AndUid({ required Map<String,dynamic> map }) {
  return MuteUser.fromJson(map);
}
BlockUser fromMapToBlocksIpv6AndUid({ required Map<String,dynamic> map }) {
  return BlockUser.fromJson(map);
}

Query<Map<String,dynamic>> returnSearchQuery({ required String collectionKey ,required List<String> searchWords }) {
  Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection(collectionKey).limit(oneTimeReadCount);
  searchWords.forEach((word) {
    query = query.where(tokenToSearchFieldKey + '.' + word,isEqualTo: true);
  });
  return query;
}

TextStyle textStyle({ required BuildContext context }) {
  return TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).highlightColor, fontSize: 16.0 );
}

final User? firebaseAuthCurrentUser = FirebaseAuth.instance.currentUser;

Future<List<MuteUser>> returnMuteUserTokens({ required String myUid }) async {
  final qshot = await tokensParentRef(uid: myUid).where(tokenTypeFieldKey,isEqualTo: muteUserTokenType).get();
  final List<MuteUser> x = qshot.docs.map((DocumentSnapshot<Map<String,dynamic>> doc) =>  MuteUser.fromJson(doc.data()!)).toList();
  return x;
}

Future<List<BlockUser>> returnBlockUserTokens({ required String myUid }) async {
  final qshot = await tokensParentRef(uid: myUid).where(tokenTypeFieldKey,isEqualTo: blockUserTokenType).get();
  final List<BlockUser> x = qshot.docs.map((DocumentSnapshot<Map<String,dynamic>> doc) =>  BlockUser.fromJson(doc.data()!)).toList();
  return x;
}