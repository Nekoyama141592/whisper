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
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
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
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';


final SettableMetadata imageMetadata = SettableMetadata(contentType: 'image/jpeg' );

final SettableMetadata postMetadata = SettableMetadata(contentType: 'video/mp4');

Reference returnUserImageParentRef({ required String uid }) => FirebaseStorage.instance.ref().child(userImagesPathKey).child(uid);

Reference returnUserImageChildRef({ required String uid, required String storageImageName }) => returnUserImageParentRef(uid: uid).child(storageImageName);

Reference returnPostImageParentRef({ required MainModel mainModel }) => FirebaseStorage.instance.ref().child(postImagesPathKey).child(mainModel.currentUser!.uid);

Reference returnPostImagePostRef({ required MainModel mainModel, required String postId }) => returnPostImageParentRef(mainModel: mainModel).child(postId);

Reference returnPostImageChildRef({ required MainModel mainModel, required String postImageName,required String postId }) => returnPostImagePostRef(mainModel: mainModel,postId: postId).child(postImageName);

Reference returnPostParentRef({ required MainModel mainModel }) => FirebaseStorage.instance.ref().child(postsPathKey).child(mainModel.currentWhisperUser.uid);

Reference returnPostChildRef({ required MainModel mainModel, required String storagePostName }) => returnPostParentRef(mainModel: mainModel).child(storagePostName);

Reference returnRefFromPost({ required Post post }) => FirebaseStorage.instance.refFromURL(post.audioURL);

WhisperUser fromMapToWhisperUser({ required Map<String,dynamic> userMap }) => WhisperUser.fromJson(userMap);

WhisperPostComment fromMapToWhisperComment({ required Map<String,dynamic> commentMap }) => WhisperPostComment.fromJson(commentMap);

Post fromMapToPost({ required Map<String,dynamic> postMap }) => Post.fromJson(postMap);

WhisperReply fromMapToWhisperReply({ required Map<String,dynamic> replyMap }) => WhisperReply.fromJson(replyMap);

UserMeta fromMapToUserMeta({ required Map<String,dynamic> userMetaMap }) => UserMeta.fromJson(userMetaMap);

ReplyNotification fromMapToReplyNotification({ required Map<String,dynamic> notificationMap }) => ReplyNotification.fromJson(notificationMap);

CommentNotification fromMapToCommentNotification({ required Map<String,dynamic> notificationmap }) => CommentNotification.fromJson(notificationmap);

NFTOwner fromMapToNFTOwner({ required Map<String,dynamic> nftOwner }) => NFTOwner.fromJson(nftOwner);

WhisperLink fromMapToWhisperLink({ required Map<String,dynamic> whisperLink }) => WhisperLink.fromJson(whisperLink);

BookmarkPostCategory fromMapToBookmarkLabel({ required Map<String,dynamic> map }) => BookmarkPostCategory.fromJson(map);

MuteUser fromMapToMutesIpv6AndUid({ required Map<String,dynamic> map }) => MuteUser.fromJson(map);

BlockUser fromMapToBlocksIpv6AndUid({ required Map<String,dynamic> map }) => BlockUser.fromJson(map);

TextStyle boldStyle() => TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis );

TextStyle boldHeaderStyle({ required BuildContext context }) => TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) );

TextStyle boldSecondaryStyle({ required BuildContext context }) => TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.secondary );

TextStyle focusHeaderStyle({ required BuildContext context }) => TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).focusColor, fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2 ,overflow: TextOverflow.ellipsis);

TextStyle highlightHeaderStyle({ required BuildContext context }) => TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).highlightColor, fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2 ,overflow: TextOverflow.ellipsis);

TextStyle whiteBoldStyle() => TextStyle(fontWeight: FontWeight.bold,color: Colors.white,overflow: TextOverflow.ellipsis );

TextStyle whiteBoldHeaderStyle({ required BuildContext context }) => TextStyle(fontWeight: FontWeight.bold,color: Colors.white,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) );

TextStyle likeStyle() => TextStyle(color: Colors.red);

TextStyle highlightStyle({ required BuildContext context }) => TextStyle(color: Theme.of(context).highlightColor );
User? firebaseAuthCurrentUser() => FirebaseAuth.instance.currentUser;

// ref
DocumentReference<Map<String,dynamic>> postDocRefToPostCommentReplyDocRef({ required DocumentReference<Map<String,dynamic>> postDocRef,required String postCommentId ,required String postCommentReplyId  }) => postDocRef.collection(postCommentsColRefName).doc(postCommentId).collection(postCommentRepliesColRefName).doc(postCommentReplyId);

DocumentReference<Map<String,dynamic>> postDocRefToPostCommentReplyLikeRef({ required DocumentReference<Map<String,dynamic>> postDocRef,required String postCommentId ,required String postCommentReplyId,required UserMeta userMeta }) => postDocRefToPostCommentReplyDocRef(postDocRef: postDocRef, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).collection(postCommentReplyLikesColRefName).doc(userMeta.uid);

CollectionReference<Map<String, dynamic>> returnUsersColRef() => FirebaseFirestore.instance.collection(usersColRefName);

DocumentReference<Map<String, dynamic>> returnUserDocRef({ required String uid }) => returnUsersColRef().doc(uid);

CollectionReference<Map<String, dynamic>> returnUserMetaColRef() => FirebaseFirestore.instance.collection(userMetaColRefName);

DocumentReference<Map<String, dynamic>> returnUserMetaDocRef({ required String uid }) => returnUserMetaColRef().doc(uid);

DocumentReference<Map<String, dynamic>> returnUserMuteDocRef({ required String passiveUid , required String activeUid }) =>  returnUserMetaDocRef(uid: passiveUid).collection(userMutesColRefName).doc(activeUid) ;

CollectionReference<Map<String,dynamic>> returnTimelinesColRef({ required String uid }) => returnUserMetaDocRef(uid: uid).collection(timelinesFieldKey);

CollectionReference<Map<String, dynamic>> returnFollowersColRef({ required String uid }) => returnUserDocRef(uid: uid).collection(followersColRefName);

DocumentReference<Map<String, dynamic>> returnFollowerDocRef({ required String uid, required String followerUid }) => returnFollowersColRef(uid: uid).doc(followerUid);

DocumentReference<Map<String,dynamic>> returnUserUpdateLogDocRef({ required String uid,required String userUpdateLogId }) => returnUserDocRef(uid: uid).collection(userUpdateLogsColRefName).doc(userUpdateLogId);

DocumentReference<Map<String,dynamic>> returnUserUpdateLogNoBatchDocRef({ required String uid,required String userUpdateLogNoBatchId }) => returnUserDocRef(uid: uid).collection(userUpdateLogNoBatchesColRefName).doc(userUpdateLogNoBatchId);

DocumentReference<Map<String,dynamic>> returnUserMetaUpdateLogDocRef({ required String uid,required String userMetaUpdateLogId }) => returnUserMetaDocRef(uid: uid).collection(userMetaUpdateLogsColRefName).doc(userMetaUpdateLogId);

CollectionReference<Map<String, dynamic>>  returnTokensColRef({ required String uid }) => returnUserMetaDocRef(uid: uid).collection(tokensColRefName);

DocumentReference<Map<String, dynamic>>  returnTokenDocRef({ required String uid , required String tokenId }) => returnTokensColRef(uid: uid).doc(tokenId);

CollectionReference<Map<String, dynamic>>  returnNotificationsColRef ({ required String uid }) => returnUserMetaDocRef(uid: uid).collection(notificationsColRefName);

DocumentReference<Map<String, dynamic>> returnNotificationDocRef({ required String uid ,required String notificationId }) => returnNotificationsColRef(uid: uid).doc(notificationId);

CollectionReference<Map<String, dynamic>> returnPostsColRef({ required String postCreatorUid }) => returnUserDocRef(uid: postCreatorUid).collection(postsColRefName);

Query<Map<String, dynamic>> returnPostsColGroupQuery() => FirebaseFirestore.instance.collectionGroup(postsColRefName);

DocumentReference<Map<String, dynamic>> returnPostDocRef({ required String postCreatorUid, required String postId }) => returnPostsColRef(postCreatorUid: postCreatorUid).doc(postId);

DocumentReference<Map<String, dynamic>> returnPostUpdateLogDocRef({ required String postCreatorUid, required String postId,required String postUpdateLogId }) => returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postUpdateLogsColRefName).doc(postUpdateLogId);

CollectionReference<Map<String, dynamic>> returnPostLikesColRef({ required String postCreatorUid,required String postId }) => returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postLikesColRefName);

DocumentReference<Map<String, dynamic>> returnPostLikeDocRef({ required String postCreatorUid,required String postId,required String activeUid }) => returnPostLikesColRef(postCreatorUid: postCreatorUid, postId: postId).doc(activeUid);

CollectionReference<Map<String, dynamic>> returnPostBookmarksColRef({ required String postCreatorUid,required String postId }) => returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postBookmarksColRefName);

DocumentReference<Map<String, dynamic>> returnPostBookmarkDocRef({ required String postCreatorUid,required String postId,required String activeUid }) => returnPostBookmarksColRef(postCreatorUid: postCreatorUid, postId: postId).doc(activeUid);

CollectionReference<Map<String, dynamic>> returnPostCommentsColRef({ required String postCreatorUid,required String postId }) => returnPostDocRef(postCreatorUid: postCreatorUid, postId: postId).collection(postCommentsColRefName);

DocumentReference<Map<String, dynamic>> returnPostCommentDocRef({ required String postCreatorUid,required String postId,required String postCommentId }) => returnPostCommentsColRef(postCreatorUid: postCreatorUid, postId: postId).doc(postCommentId);

CollectionReference<Map<String, dynamic>> returnPostCommentLikesColRef({ required String postCreatorUid,required String postId,required String postCommentId }) => returnPostCommentDocRef(postCreatorUid: postCreatorUid, postId: postId,postCommentId: postCommentId ).collection(postCommentLikesColRefName);

DocumentReference<Map<String, dynamic>> returnPostCommentLikeDocRef({ required String postCreatorUid,required String postId ,required String activeUid,required String postCommentId }) => returnPostCommentLikesColRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId ).doc(activeUid);

CollectionReference<Map<String, dynamic>> returnPostCommentRepliesColRef({ required String postCreatorUid,required String postId ,required String postCommentId }) => returnPostCommentDocRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId).collection(postCommentRepliesColRefName);

DocumentReference<Map<String, dynamic>> returnPostCommentReplyDocRef({ required String postCreatorUid,required String postId,required String postCommentId,required String postCommentReplyId }) => returnPostCommentRepliesColRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId).doc(postCommentReplyId);

CollectionReference<Map<String, dynamic>> returnPostCommentReplyLikesColRef({ required String postCreatorUid,required String postId,required String postCommentId, required String postCommentReplyId }) => returnPostCommentReplyDocRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).collection(postCommentReplyLikesColRefName);

DocumentReference<Map<String, dynamic>> returnPostCommentReplyLikeDocRef({ required String postCreatorUid,required String postId,required String postCommentId, required String postCommentReplyId ,required String activeUid }) => returnPostCommentReplyLikesColRef(postCreatorUid: postCreatorUid, postId: postId, postCommentId: postCommentId, postCommentReplyId: postCommentReplyId).doc(activeUid);

CollectionReference<Map<String, dynamic>> returnOfficialAdvertisementsColRef() => FirebaseFirestore.instance.collection(officialAdvertisementsColRefName);

DocumentReference<Map<String, dynamic>> returnOfficialAdvertisementDocRef ({ required String officialAdvertisementId }) => returnOfficialAdvertisementsColRef().doc(officialAdvertisementId);

CollectionReference<Map<String, dynamic>> returnOfficialAdvertisementImpressionsColRef ({ required String officialAdvertisementId }) => returnOfficialAdvertisementDocRef(officialAdvertisementId: officialAdvertisementId).collection(officialAdvertisementImperssionsColRefName);

DocumentReference<Map<String, dynamic>> returnOfficialAdvertisementImpressionDocRef ({ required String officialAdvertisementId ,required String officialAdvertisementImpressionId }) => returnOfficialAdvertisementImpressionsColRef(officialAdvertisementId: officialAdvertisementId).doc(officialAdvertisementImpressionId);

CollectionReference<Map<String, dynamic>> returnOfficialAdvertisementConfigColRef() => FirebaseFirestore.instance.collection(officialAdvertisementConfigColRefName);

DocumentReference<Map<String, dynamic>> returnOfficialAdvertisementConfigDocRef() => returnOfficialAdvertisementConfigColRef().doc(configIdString);

DocumentReference<Map<String,dynamic>> returnPostReportDocRef({ required DocumentSnapshot<Map<String,dynamic>> postDoc,required String postReportId }) => postDoc.reference.collection(postReportsColRefName).doc(postReportId) ;

DocumentReference<Map<String,dynamic>> returnPostCommentReportDocRef({ required DocumentSnapshot<Map<String,dynamic>> postCommentDoc,required String postCommentReportId }) => postCommentDoc.reference.collection(postCommentReportsColRefName).doc(postCommentReportId);

DocumentReference<Map<String,dynamic>> returnPostCommentReplyReportDocRef({ required DocumentSnapshot<Map<String,dynamic>> postCommentReplyDoc,required String postCommentReplyReportId }) => postCommentReplyDoc.reference.collection(postCommentReplyReportsColRefName).doc(postCommentReplyReportId);

DocumentReference<Map<String,dynamic>> returnPostMuteDocRef({ required DocumentSnapshot<Map<String,dynamic>> postDoc,required UserMeta userMeta }) => postDoc.reference.collection(postMutesColRefName).doc(userMeta.uid) ;

DocumentReference<Map<String,dynamic>> returnPostCommentMuteDocRef({ required DocumentReference<Map<String,dynamic>> postCommentDocRef,required UserMeta userMeta  }) => postCommentDocRef.collection(postCommentMutesColRefName).doc(userMeta.uid);

DocumentReference<Map<String,dynamic>> returnPostCommentReplyMuteDocRef({ required DocumentReference<Map<String,dynamic>> postCommentReplyDocRef,required UserMeta userMeta }) => postCommentReplyDocRef.collection(postCommentReplyMutesColRefName).doc(userMeta.uid);

Future<File?> returnCroppedFile ({ required XFile? xFile }) async {
  final instance = ImageCropper();
  final File? result = await instance.cropImage(
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
// localize
L10n? returnL10n({ required BuildContext context }) => L10n.of(context);