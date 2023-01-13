// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/domain/official_advertisement/official_advertisement.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/whisper_reply/whisper_reply.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
import 'package:whisper/domain/whisper_post_comment/whisper_post_comment.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required String uid,}) => ( !mutesUids.contains(uid) && !blocksUids.contains(uid) );

bool basicScanOfPost({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required String uid, required List<dynamic> mutesPostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  final Post post = fromMapToPost(postMap: doc.data()!);
  return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, uid: uid,) && !mutesPostIds.contains(post.postId);
}

bool newNotificationExists({ required List<CommentNotification> commentNotifications,required List<ReplyNotification> replyNotifications }) {
  bool x = false;
  for (final replyNotification in replyNotifications) if (replyNotification.isRead == false) x = true;
  for (final commentNotification in replyNotifications) if (commentNotification.isRead == false) x = true;
  return x;
}

bool isValidReadPost({ required Post whisperPost,required PostType postType ,required List<dynamic> muteUids, required List<dynamic> blockUids, required String uid, required List<dynamic> mutePostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  switch(postType) {
    case PostType.bookmarks:
    return isNotNegativePost(whisperPost: whisperPost);

    case PostType.feeds:
    return isNotNegativePost(whisperPost: whisperPost) && basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc );

    case PostType.myProfile:
    return isNotNegativePost(whisperPost: whisperPost);

    case PostType.postSearch:
    return isNotNegativePost(whisperPost: whisperPost) && basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc );

    case PostType.recommenders:
    final now = DateTime.now();
    final DateTime range = now.subtract(Duration(days: 5));
    final Post post = fromMapToPost(postMap: doc.data()!);
    return isNotNegativePost(whisperPost: whisperPost) && basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc ) && !mutePostIds.contains(post.postId) && (Post.fromJson(doc.data()!).createdAt as Timestamp).toDate().isAfter(range);

    case PostType.userShow:
    return isNotNegativePost(whisperPost: whisperPost);

    case PostType.onePost:
    return isNotNegativePost(whisperPost: whisperPost);
    
    case PostType.createPost:
    return true;
  }
}
bool isImageExist({ required Post post }) {
  bool isImageExist = false;
  for (final element in post.imageURLs) if (element.isNotEmpty) isImageExist = true;
  return isImageExist;
}
bool canShowAdvertisement({ required OfficialAdvertisement officialAdvertisement }) {
  final iCount = officialAdvertisement.impressionCount;
  final iLimit = officialAdvertisement.impressionCountLimit;
  if (firebaseAuthCurrentUser() == null) {
    return false;
  } else {
    if (iCount >= 0 && iLimit >= 0) {
      if (iLimit == 0) {
        // there is no limit
        return true;
      } else if (iLimit > iCount) {
        // basic
        return true;
      } else {
        // iCount >= 0
        return false;
      }
    } else {
      // strange
      return false;
    }
  }
}
bool isNotNegativeComment({ required DocumentSnapshot<Map<String,dynamic>> commentDoc  }) {
  final WhisperPostComment whisperComment =  WhisperPostComment.fromJson(commentDoc.data()!);
  return whisperComment.commentNegativeScore < negativeScoreLimit || whisperComment.uid == firebaseAuthCurrentUser()!.uid;
}
bool isNotNegativeReply({ required DocumentSnapshot<Map<String,dynamic>> replyDoc  }) {
  final WhisperReply whisperReply = WhisperReply.fromJson(replyDoc.data()!);
  return whisperReply.replyNegativeScore < negativeScoreLimit || whisperReply.uid == firebaseAuthCurrentUser()!.uid;
}
bool isNotNegativePost({ required Post whisperPost  }) => whisperPost.titleNegativeScore < negativeScoreLimit || whisperPost.uid == firebaseAuthCurrentUser()!.uid;

bool isNotNegativeUser({ required DocumentSnapshot<Map<String,dynamic>> userDoc}) {
  final WhisperUser whisperUser = WhisperUser.fromJson(userDoc.data()!);
  return whisperUser.userNameNegativeScore < negativeScoreLimit || whisperUser.uid == firebaseAuthCurrentUser()!.uid;
} 

bool isNotNegativeBasicContent({ required BasicDocType basicDocType,required DocumentSnapshot<Map<String,dynamic>> doc }) {
  switch(basicDocType){
    case BasicDocType.muteUser:
    return true;
    case BasicDocType.commentNotification:
    return true;
    case BasicDocType.replyNotification:
    return true;
    case BasicDocType.postComment:
    return isNotNegativeComment(commentDoc: doc);
    case BasicDocType.postCommentReply:
    return isNotNegativeReply(replyDoc: doc);
    case BasicDocType.searchedUser:
    return isNotNegativeUser(userDoc: doc);
  }
}