import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final followProvider = ChangeNotifierProvider(
  (ref) => FollowModel()
);
class FollowModel extends ChangeNotifier {

  Future follow(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    await addFollowingUidOfActiveUser(followingUids,currentUserDoc, passiveUserDoc);
    await addFollowerUidOfPassiveUser(currentUserDoc, passiveUserDoc);
  }

  Future unfollow(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    await removeFollowingUidOfActiveUser(followingUids,currentUserDoc, passiveUserDoc);
    await removeFollowerUidOfPassiveUser(currentUserDoc, passiveUserDoc);
  }
  Future addFollowingUidOfActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      // final String newFollowingUid = passiveUserDoc['uid'];
      // followingUids.add(newFollowingUid);
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

  Future addFollowerUidOfPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
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

  Future removeFollowingUidOfActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      // final String removeFollowingUid = passiveUserDoc['uid'];
      // followingUids.remove(removeFollowingUid);
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

  Future removeFollowerUidOfPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      final List<dynamic> followerUids = passiveUserDoc['followerUids'];
      final String removeFollowerUid = currentUserDoc['uid'];
      followerUids.remove(removeFollowerUid);
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