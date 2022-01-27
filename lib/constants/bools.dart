// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required Map<String,dynamic> map}) {
  // use on comments or replys on display
  final String uid = map[uidKey];
  final String ipv6 = map[ipv6Key];
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) && !blocksIpv6s.contains(ipv6) ) ;
}

bool basicScanOfPost({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s, required List<dynamic> blocksIpv6s,required String uid, required String ipv6, required List<dynamic> mutesPostIds, required DocumentSnapshot<Map<String,dynamic>> doc }) {
  final Post post = fromMapToPost(postMap: doc.data()!);
  return isDisplayUidFromMap(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, map: doc.data()! ) && !mutesPostIds.contains(post.postId);
}

bool isDisplayShowPage({ required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> passiveBlocksUids, required MainModel mainModel }) {
  // use on display user show page
  final String myUid = mainModel.currentWhisperUser.uid;
  return ( !mutesUids.contains(myUid) && blocksUids.contains(myUid) && passiveBlocksUids.contains(myUid) );
}

bool newNotificationExists({ required List<CommentNotification> commentNotifications,required List<ReplyNotification> replyNotifications }) {
  bool x = false;
  replyNotifications.forEach((replyNotification) { if (replyNotification.isRead == false) { x = true; } });
  commentNotifications.forEach((commentNotification) { if (commentNotification.isRead == false) { x = true; } });
  return x;
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
    final Post post = fromMapToPost(postMap: doc.data()!);
    return basicScanOfPost(mutesUids: mutesUids, blocksUids: blocksUids, mutesIpv6s: mutesIpv6s, blocksIpv6s: blocksIpv6s, uid: uid, ipv6: ipv6, mutesPostIds: mutesPostIds, doc: doc ) && !mutesPostIds.contains(post.postId) && (doc[createdAtKey] as Timestamp).toDate().isAfter(range);

    case PostType.userShow:
    return true;

    case PostType.onePost:
    return true;
  }
}

