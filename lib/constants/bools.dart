bool isDisplayUid({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s,required String uid, required String ipv6,}) {
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) ) ;
}

bool isDisplayUidFromMap({required List<dynamic> mutesUids, required List<dynamic> blocksUids, required List<dynamic> mutesIpv6s,required Map<String,dynamic> map}) {
  final String uid = map['uid'];
  final String ipv6 = map['ipv6'];
  return ( !mutesUids.contains(uid) && !blocksUids.contains(uid) && !mutesIpv6s.contains(ipv6) ) ;
}
