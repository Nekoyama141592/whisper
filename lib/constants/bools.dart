// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/domain/official_advertisement/official_advertisement.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required String uid,}) {
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) ) ;
}

bool basicScanOfPost({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required String uid, required List<dynamic> mutesPostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  final Post post = fromMapToPost(postMap: doc.data()!);
  return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, uid: uid,) && !mutesPostIds.contains(post.postId);
}

bool isDisplayShowPage({ required bool isBlocked, required MainModel mainModel }) {
  // use on display user show page
  final String myUid = mainModel.currentWhisperUser.uid;
  return ( !mainModel.muteUids.contains(myUid) && mainModel.blockUids.contains(myUid)  );
}

bool newNotificationExists({ required List<CommentNotification> commentNotifications,required List<ReplyNotification> replyNotifications }) {
  bool x = false;
  replyNotifications.forEach((replyNotification) { if (replyNotification.isRead == false) { x = true; } });
  commentNotifications.forEach((commentNotification) { if (commentNotification.isRead == false) { x = true; } });
  return x;
}

bool isValidReadPost({ required PostType postType ,required List<dynamic> muteUids, required List<dynamic> blockUids, required String uid, required List<dynamic> mutePostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  // post is DocumentSnapshot<Map<String,dynamic>> or Map<String,dynamic>
  switch(postType) {
    case PostType.bookmarks:
    return true;

    case PostType.feeds:
    return basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc );

    case PostType.myProfile:
    return true;

    case PostType.postSearch:
    return basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc );

    case PostType.recommenders:
    final now = DateTime.now();
    final DateTime range = now.subtract(Duration(days: 5));
    final Post post = fromMapToPost(postMap: doc.data()!);
    return basicScanOfPost(mutesUids: muteUids, blocksUids: blockUids, uid: uid, mutesPostIds: mutePostIds, doc: doc ) && !mutePostIds.contains(post.postId) && (Post.fromJson(doc.data()!).createdAt as Timestamp).toDate().isAfter(range);

    case PostType.userShow:
    return true;

    case PostType.onePost:
    return true;
  }
}
bool isImageExist({ required Post post }) {
  bool isImageExist = false;
  post.imageURLs.forEach((element) { 
    if (element.isNotEmpty) {
      isImageExist = true;
    }
  });
  return isImageExist;
}
bool canShowAdvertisement({ required OfficialAdvertisement officialAdvertisement }) {
  if (officialAdvertisement.tapCountLimit == 0 && officialAdvertisement.impressionCountLimit == 0) {
    // no limit
    return true;
  } else if (officialAdvertisement.tapCountLimit >= 0 && officialAdvertisement.impressionCountLimit >= 0) {
    // strange
    return false;
  } else if (officialAdvertisement.tapCountLimit == 0 && officialAdvertisement.impressionCountLimit >= 0 ) {
    // there is imperssionCountLimit
    if (officialAdvertisement.tapCount < officialAdvertisement.tapCountLimit) {
      return true;
    } else {
      return false;
    }
  } else if (officialAdvertisement.tapCountLimit >= 0 && officialAdvertisement.impressionCountLimit == 0 ) {
    // there is tapCountLimit
    if (officialAdvertisement.impressionCount < officialAdvertisement.impressionCountLimit ) {
      return true;
    } else {
      return false;
    }
  } else {
    // officialAdvertisement.tapCountLimit <= 0 && officialAdvertisement.impressionCountLimit <= 0 
    // strange
    return false;
  }
}
