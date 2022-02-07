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
import 'package:whisper/domain/bookmark_post_label/bookmark_post_label.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/nft_owner/nft_owner.dart';
import 'package:whisper/domain/reply/whipser_reply.dart';
import 'package:whisper/domain/user_meta/user_meta.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
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
final SettableMetadata imageMetadata = SettableMetadata(contentType: 'image/jpeg' );
final SettableMetadata postMetadata = SettableMetadata(contentType: 'video/mp4');

Reference returnUserImageParentRef({ required String uid }) {
  return FirebaseStorage.instance.ref().child(userImagesPathKey).child(uid);
}

Reference returnUserImageChildRef({ required String uid, required String storageImageName }) {
  final parentRef = returnUserImageParentRef(uid: uid);
  return parentRef.child(storageImageName);
}

Reference returnPostImageParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postImagesPathKey).child(mainModel.currentUser!.uid);
}

Reference returnPostImagePostRef({ required MainModel mainModel, required String postId }) {
  return returnPostImageParentRef(mainModel: mainModel).child(postId);
}

Reference returnPostImageChildRef({ required MainModel mainModel, required String postImageName,required String postId }) {
  return returnPostImagePostRef(mainModel: mainModel,postId: postId).child(postImageName);
}

Reference returnPostParentRef({ required MainModel mainModel }) {
  return FirebaseStorage.instance.ref().child(postPathKey).child(mainModel.currentWhisperUser.uid);
}

Reference returnPostChildRef({ required MainModel mainModel, required String storagePostName }) {
  return returnPostParentRef(mainModel: mainModel).child(storagePostName);
}

Reference returnRefFromPost({ required Post post }) {
  return FirebaseStorage.instance.refFromURL(post.audioURL);
}

CollectionReference<Map<String, dynamic>> returnUsersColRef() { return FirebaseFirestore.instance.collection(usersColRefName); }
DocumentReference<Map<String, dynamic>> returnUserDocRef({ required String uid }) { return returnUsersColRef().doc(uid); }
CollectionReference<Map<String, dynamic>> returnUserMetaColRef() { return FirebaseFirestore.instance.collection(userMetaColRefName); }
DocumentReference<Map<String, dynamic>> returnUserMetaDocRef({ required String uid }) { return returnUserMetaColRef().doc(uid); }
CollectionReference<Map<String,dynamic>> returnTimelinesColRef({ required String uid }) { return returnUserMetaDocRef(uid: uid).collection(timelinesFieldKey); }
CollectionReference<Map<String, dynamic>> returnFollowersColRef({ required String uid }) { return returnUserDocRef(uid: uid).collection(followersColRefName); }
DocumentReference<Map<String, dynamic>> returnFollowerDocRef({ required String uid, required String followerUid }) { return returnFollowersColRef(uid: uid).doc(followerUid); }
CollectionReference<Map<String, dynamic>>  returnTokensColRef({ required String uid }) { return returnUserMetaDocRef(uid: uid).collection(tokensColRefName); }
DocumentReference<Map<String, dynamic>>  returnTokenDocRef({ required String uid , required String tokenId }) { return returnTokensColRef(uid: uid).doc(tokenId); }
CollectionReference<Map<String, dynamic>>  returnNotificationsColRef ({ required String uid }) { return returnUserMetaDocRef(uid: uid).collection(notificationsColRefName); }
DocumentReference<Map<String, dynamic>> returnNotificationDocRef({ required String uid ,required String notificationId }) { return returnNotificationsColRef(uid: uid).doc(notificationId); }
CollectionReference<Map<String, dynamic>> returnPostsColRef({ required String postCreatorUid }) { return returnUserDocRef(uid: postCreatorUid).collection(postsColRefName); }
final Query<Map<String, dynamic>> returnPostsColGroupQuery = FirebaseFirestore.instance.collectionGroup(postsColRefName);
DocumentReference<Map<String, dynamic>> returnPostDocRef({ required String postCreatorUid, required String postId }) { return returnPostsColRef(postCreatorUid: postCreatorUid).doc(postId); }
CollectionReference<Map<String, dynamic>> returnPostLikesColRef({ required String postCreatorUid,required String postId }) { return returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postLikesColRefName); }
DocumentReference<Map<String, dynamic>> returnPostLikeDocRef({ required String postCreatorUid,required String postId,required String activeUid }) { return returnPostLikesColRef(postCreatorUid: postCreatorUid, postId: postId).doc(activeUid);  }
CollectionReference<Map<String, dynamic>> returnPostBookmarksColRef({ required String postCreatorUid,required String postId }) { return returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postBookmarksColRefName); }
DocumentReference<Map<String, dynamic>> returnPostBookmarkDocRef({ required String postCreatorUid,required String postId,required String activeUid }) { return returnPostBookmarksColRef(postCreatorUid: postCreatorUid, postId: postId).doc(activeUid);  }
CollectionReference<Map<String, dynamic>> returnPostCommentsColRef({ required String postCreatorUid,required String postId }) { return returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postCommentsColRefName); }
DocumentReference<Map<String, dynamic>> returnPostCommentDocRef({ required String postCreatorUid,required String postId,required String postCommentId }) { return returnPostCommentsColRef(postCreatorUid: postCreatorUid, postId: postId).doc(postCommentId);  }
CollectionReference<Map<String, dynamic>> returnPostCommentLikesColRef({ required String postCreatorUid,required String postId }) { return returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postCommentLikesColRefName);  }
DocumentReference<Map<String, dynamic>> returnPostCommentLikeDocRef({ required String postCreatorUid,required String postId ,required String activeUid }) { return returnPostCommentLikesColRef(postCreatorUid: postCreatorUid, postId: postId).doc(activeUid); }
CollectionReference<Map<String, dynamic>> returnPostCommentReplysColRef({ required String postCreatorUid,required String postId ,required String postCommentId }) { return returnPostCommentDocRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId).collection(postCommentReplysColRefName);  }
DocumentReference<Map<String, dynamic>> returnPostCommentReplyDocRef({ required String postCreatorUid,required String postId,required String postCommentId,required String postCommentReplyId }) { return returnPostCommentReplysColRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId).doc(postCommentReplyId); }
CollectionReference<Map<String, dynamic>> returnPostCommentReplyLikesColRef({ required String postCreatorUid,required String postId,required String postCommentId, required String postCommentReplyId }) { return returnPostCommentReplyDocRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).collection(postCommentReplyLikesColRefName); }
DocumentReference<Map<String, dynamic>> returnPostCommentReplyLikeDocRef({ required String postCreatorUid,required String postId,required String postCommentId, required String postCommentReplyId ,required String activeUid }) { return returnPostCommentReplyLikesColRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).doc(activeUid); }

WhisperUser fromMapToWhisperUser({ required Map<String,dynamic> userMap }) {
  return WhisperUser.fromJson(userMap);
}
WhisperPostComment fromMapToWhisperComment({ required Map<String,dynamic> commentMap }) {
  return WhisperPostComment.fromJson(commentMap);
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

BookmarkPostLabel fromMapToBookmarkLabel({ required Map<String,dynamic> map }) {
  return BookmarkPostLabel.fromJson(map);
}
MuteUser fromMapToMutesIpv6AndUid({ required Map<String,dynamic> map }) {
  return MuteUser.fromJson(map);
}
BlockUser fromMapToBlocksIpv6AndUid({ required Map<String,dynamic> map }) {
  return BlockUser.fromJson(map);
}

Query<Map<String,dynamic>> returnPostSearchQuery({ required String postCreatorUid ,required List<String> searchWords }) {
  Query<Map<String,dynamic>> query = returnPostsColRef(postCreatorUid: postCreatorUid).limit(oneTimeReadCount);
  searchWords.forEach((word) {
    query = query.where(searchTokenFieldKey + '.' + word,isEqualTo: true);
  });
  return query;
}
Query<Map<String,dynamic>> returnUserSearchQuery({ required List<String> searchWords }) {
  Query<Map<String,dynamic>> query = returnUsersColRef().limit(oneTimeReadCount);
  searchWords.forEach((word) {
    query = query.where(searchTokenFieldKey + '.' + word,isEqualTo: true);
  });
  return query;
}

TextStyle textStyle({ required BuildContext context }) {
  return TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).highlightColor, fontSize: MediaQuery.of(context).size.height/32.0 ,overflow: TextOverflow.ellipsis);
}

TextStyle cancelStyle({ required BuildContext context }) {
  return TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).focusColor, fontSize: MediaQuery.of(context).size.height/32.0 ,overflow: TextOverflow.ellipsis);
}


final User? firebaseAuthCurrentUser = FirebaseAuth.instance.currentUser;

DocumentReference<Map<String,dynamic>> postDocRefToPostCommentReplyDocRef({ required DocumentReference<Map<String,dynamic>> postDocRef,required String postCommentId ,required String postCommentReplyId  }) {
  return postDocRef.collection(postCommentsColRefName).doc(postCommentId).collection(postCommentReplysColRefName).doc(postCommentReplyId);
}

DocumentReference<Map<String,dynamic>> postDocRefToPostCommentReplyLikeRef({ required DocumentReference<Map<String,dynamic>> postDocRef,required String postCommentId ,required String postCommentReplyId,required UserMeta userMeta }) {
  return postDocRefToPostCommentReplyDocRef(postDocRef: postDocRef, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).collection(postCommentReplysColRefName).doc(userMeta.uid);
}