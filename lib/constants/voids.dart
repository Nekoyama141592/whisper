// packages
import 'package:cloud_firestore/cloud_firestore.dart';

void addMutesUidAndMutesIpv6AndUid({ required List<dynamic> mutesUids, required List<dynamic> mutesIpv6AndUids, required Map<String,dynamic> map}) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  mutesUids.add(uid);
  mutesIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateMutesIpv6AndUids({ required List<dynamic> mutesIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'mutesIpv6AndUids': mutesIpv6AndUids,
  }); 
}

void addBlocksUidsAndBlocksIpv6AndUid({ required List<dynamic> blocksUids, required List<dynamic> blocksIpv6AndUids, required Map<String,dynamic> map }) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  blocksUids.add(uid);
  blocksIpv6AndUids.add({
    'ipv6': ipv6,
    'uid': uid,
  });
}

Future<void> updateBlocksIpv6AndUids({ required List<dynamic> blocksIpv6AndUids, required DocumentSnapshot currentUserDoc}) async {
  await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
  .update({
    'blocksIpv6AndUids': blocksIpv6AndUids,
  }); 
}