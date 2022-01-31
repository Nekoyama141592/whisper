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

Reference postImagePostRef({ required MainModel mainModel, required String postId }) {
  return postImageParentRef(mainModel: mainModel).child(postId);
}

Reference postImageChildRef({ required MainModel mainModel, required String postImageName,required String postId }) {
  return postImagePostRef(mainModel: mainModel,postId: postId).child(postImageName);
}

Reference postParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postsFieldKey).child(mainModel.currentWhisperUser.uid);
}

Reference postChildRef({ required MainModel mainModel, required String storagePostName }) {
  return postParentRef(mainModel: mainModel).child(storagePostName);
}

Reference refFromPost({ required Post post }) {
  return FirebaseStorage.instance.refFromURL(post.audioURL);
}

CollectionReference<Map<String, dynamic>> followersParentRef({ required String passiveUid }) {
  return FirebaseFirestore.instance.collection(usersFieldKey).doc(passiveUid).collection(followersFieldKey);
}

DocumentReference<Map<String, dynamic>> followerChildRef({ required String passiveUid , required String followerUid}) {
  final parentRef = followersParentRef(passiveUid: passiveUid);
  return parentRef.doc(followerUid);
}

CollectionReference<Map<String, dynamic>> usersColRef() { return FirebaseFirestore.instance.collection('users'); }
DocumentReference<Map<String, dynamic>> userDocRef({ required String uid }) { return usersColRef().doc(uid); }
CollectionReference<Map<String, dynamic>> followersColRef({ required String uid }) { return userDocRef(uid: uid).collection('followers'); }
DocumentReference<Map<String, dynamic>> followerDocRef({ required String uid, required String followerUid }) { return followersColRef(uid: uid).doc(followerUid); }
CollectionReference<Map<String, dynamic>>  tokensColRef({ required String uid }) { return userDocRef(uid: uid).collection('tokens'); }
DocumentReference<Map<String, dynamic>>  tokenDocRef({ required String uid , required String tokenId }) { return tokensColRef(uid: uid).doc(tokenId); }
CollectionReference<Map<String, dynamic>>  notificationsColRef ({ required String uid }) { return userDocRef(uid: uid).collection('notifications'); }
DocumentReference<Map<String, dynamic>> notificationDocRef({ required String uid ,required String notificationId }) { return notificationsColRef(uid: uid).doc(notificationId); }
CollectionReference<Map<String, dynamic>> postsColRef({ required String uid }) { return userDocRef(uid: uid).collection('posts'); }
final Query<Map<String, dynamic>> postsColGroupQuery = FirebaseFirestore.instance.collectionGroup('posts');
DocumentReference<Map<String, dynamic>> postDocRef({ required String uid, required String postId }) { return postsColRef(uid: uid).doc(postId); }
CollectionReference<Map<String, dynamic>> postLikesColRef({ required String uid,required String postId }) { return postDocRef(uid: uid, postId: postId).collection('postLikes'); }
DocumentReference<Map<String, dynamic>> postLikeDocRef({ required String uid,required String postId,required String activeUid }) { return postLikesColRef(uid: uid, postId: postId).doc(activeUid);  }
CollectionReference<Map<String, dynamic>> postBookmarksColRef({ required String uid,required String postId }) { return postDocRef(uid: uid, postId: postId).collection('postBookmarks'); }
DocumentReference<Map<String, dynamic>> postBookmarkDocRef({ required String uid,required String postId,required String activeUid }) { return postLikesColRef(uid: uid, postId: postId).doc(activeUid);  }
CollectionReference<Map<String, dynamic>> postCommentsColRef({ required String uid,required String postId }) { return postDocRef(uid: uid, postId: postId).collection('postComments'); }
final Query<Map<String,dynamic>> postCommentsColGroupQuery = FirebaseFirestore.instance.collectionGroup('postComments');
DocumentReference<Map<String, dynamic>> postCommentDocRef({ required String uid,required String postId,required String postCommentId }) { return postCommentsColRef(uid: uid, postId: postId).doc(postCommentId);  }
CollectionReference<Map<String, dynamic>> postCommentLikesColRef({ required String uid,required String postId }) { return postDocRef(uid: uid, postId: postId).collection('postCommentLikes');  }
DocumentReference<Map<String, dynamic>> postCommentLikeDocRef({ required String uid,required String postId ,required String activeUid }) { return postCommentLikesColRef(uid: uid, postId: postId).doc(activeUid); }
CollectionReference<Map<String, dynamic>> postCommentReplysColRef({ required String uid,required String postId ,required String postCommentId }) { return postCommentDocRef(uid: uid, postId: postId, postCommentId: postCommentId).collection('postCommentReplys');  }
final Query<Map<String,dynamic>> postCommentReplysColGroupQuery = FirebaseFirestore.instance.collectionGroup('postCommentReplys');
DocumentReference<Map<String, dynamic>> postCommentReplyDocRef({ required String uid,required String postId,required String postCommentId,required String postCommentReplyId }) { return postCommentReplysColRef(uid: uid, postId: postId, postCommentId: postCommentId).doc(postCommentReplyId); }
CollectionReference<Map<String, dynamic>> postCommentReplyLikesColRef({ required String uid,required String postId,required String postCommentId, required String postCommentReplyId }) { return postCommentReplyDocRef(uid: uid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).collection('postCommentReplyLikes'); }
DocumentReference<Map<String, dynamic>> postCommentReplyLikeDocRef({ required String uid,required String postId,required String postCommentId, required String postCommentReplyId ,required String activeUid }) { return postCommentReplyLikesColRef(uid: uid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).doc(activeUid); }

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