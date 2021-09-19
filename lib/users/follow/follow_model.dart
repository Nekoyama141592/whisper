import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final followProvider = ChangeNotifierProvider(
  (ref) => FollowModel()
);
class FollowModel extends ChangeNotifier {

  Future follow(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    await updateFollowUidsOfActiveUser(followingUids,currentUserDoc, passiveUserDoc);
    await updateFollowerUidsOfPassiveUser(currentUserDoc, passiveUserDoc);
  }

  Future updateFollowUidsOfActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      final String newFollowUid = passiveUserDoc['uid'];
      followingUids.add(newFollowUid);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserDoc.id)
      .update({
        'followingUids': followingUids,
      });
    } catch(e) {
      print(e.toString());
    } 
  }

  Future updateFollowerUidsOfPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      final List<dynamic> followerUids = passiveUserDoc['followerUids'];
      final String newFollowerUid = currentUserDoc['uid'];
      followerUids.add(newFollowerUid);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(passiveUserDoc.id)
      .update({
        'followerUids': followerUids,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  void reload() {
    notifyListeners();
  }
}