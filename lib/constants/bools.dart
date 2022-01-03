// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/strings.dart';
// model
import 'package:whisper/main_model.dart';

bool isDisplayUid({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required String uid, required String ipv6,}) {
  // use on makeReplyNotification or makeCommentNotification
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) && !blocksIpv6s.contains(ipv6) ) ;
}

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required Map<String,dynamic> map}) {
  // use on comments or replys on display
  final String uid = map[uidKey];
  final String ipv6 = map[ipv6Key];
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) && !blocksIpv6s.contains(ipv6) ) ;
}

bool basicScanOfPost({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required String uid, required String ipv6, required List<dynamic> mutesPostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: doc.data()! ) && !mutesPostIds.contains(doc[postIdKey]);
}

bool isDisplayShowPage({ required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> passiveBlocksUids, required DocumentSnapshot currentUserDoc }) {
  // use on display user show page
  final String myUid = currentUserDoc[uidKey];
  return ( !mutesUids.contains(myUid) && blocksUids.contains(myUid) && passiveBlocksUids.contains(myUid) );
}

bool newNotificationExists({ required MainModel mainModel }) {
  bool x = false;
  mainModel.replyNotifications.forEach((replyNotification) {
    final notificationId = replyNotification[notificationIdKey];
    if (!mainModel.readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  mainModel.commentNotifications.forEach((commentNotification) {
    final notificationId = commentNotification[notificationIdKey];
    if (!mainModel.readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  return x;
}

bool isNotiRecentNotification({ required Map<String,dynamic> notification}) {
  final now = DateTime.now();
  final DateTime range = now.subtract(Duration(days: 5));
  return notification[createdAtKey].toDate().isBefore(range);
}

bool isValidReadPost({ required PostType postType ,required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required String uid, required String ipv6, required List<dynamic> mutesPostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  // post is DocumentSnapshot<Map<String,dynamic>> or Map<String,dynamic>
  switch(postType) {
    case PostType.bookmarks:
    return true;

    case PostType.feeds:
    return basicScanOfPost(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc );

    case PostType.myProfile:
    return true;

    case PostType.postSearch:
    return basicScanOfPost(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc );

    case PostType.recommenders:
    final now = DateTime.now();
    final DateTime range = now.subtract(Duration(days: 5));
    return basicScanOfPost(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc ) && !mutesPostIds.contains(doc[postIdKey]) && doc[createdAtKey].toDate().isAfter(range);

    case PostType.userShow:
    return true;
  }
}

