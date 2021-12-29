// material
import 'package:cloud_firestore/cloud_firestore.dart';
// model
import 'package:whisper/main_model.dart';

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

bool newNotificationExists({ required MainModel mainModel }) {
  bool x = false;
  mainModel.replyNotifications.forEach((replyNotification) {
    final notificationId = replyNotification['notificationId'];
    if (!mainModel.readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  mainModel.commentNotifications.forEach((commentNotification) {
    final notificationId = commentNotification['notificationId'];
    if (!mainModel.readNotificationIds.contains(notificationId)) {
      x = true;
    }
  });
  return x;
}

bool isNotiRecentNotification({ required Map<String,dynamic> notification}) {
  final now = DateTime.now();
  final DateTime range = now.subtract(Duration(days: 5));
  return notification['createdAt'].toDate().isBefore(range);
}