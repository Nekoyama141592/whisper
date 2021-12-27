// material
import 'package:cloud_firestore/cloud_firestore.dart';

bool isDisplayUid({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required String uid, required String ipv6,}) {
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) && !blocksIpv6s.contains(ipv6) ) ;
}

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required Map<String,dynamic> map}) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) && !blocksIpv6s.contains(ipv6) ) ;
}

bool isDisplayShowPage({ required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> passiveBlocksUids, required DocumentSnapshot currentUserDoc }) {
  final String myUid = currentUserDoc['uid'];
  return ( !mutesUids.contains(myUid) && blocksUids.contains(myUid) && passiveBlocksUids.contains(myUid) );
}

bool newNotificationExists({ required List<dynamic> readNotificationIds, required DocumentSnapshot currentUserDoc }) {
  List<dynamic> replyNotifications = currentUserDoc['replyNotifications'];
  bool x = false;
  replyNotifications.forEach((replyNotification) {
    final notificationId = replyNotification['notificationId'];
    if (!readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  List<dynamic> commentNotifications = currentUserDoc['commentNotifications'];
  commentNotifications.forEach((commentNotification) {
    final notificationId = commentNotification['notificationId'];
    if (!readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  return x;
}