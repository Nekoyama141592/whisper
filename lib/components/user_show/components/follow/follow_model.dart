import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


final followProvider = ChangeNotifierProvider(
  (ref) => FollowModel()
);
class FollowModel extends ChangeNotifier {

  Future follow(BuildContext context,List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    if (followingUids.length >= 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('フォローできるのは500人までです')));
    } else {
      followingUids.add(passiveUserDoc['uid']);
      notifyListeners();
      final DocumentSnapshot newPassiveUserDoc = await getNewPassiveUserDoc(passiveUserDoc);
      await addFollowingUidToActiveUser(followingUids,currentUserDoc, passiveUserDoc);
      await addFollowerUidToPassiveUser(currentUserDoc, newPassiveUserDoc);
    }
  }

  Future addFollowingUidToActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
      await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
      .update({
        'followingUids': followingUids,
      });
    } catch(e) {
      print(e.toString());
    } 
  }

  Future addFollowerUidToPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot newPassiveUserDoc) async {
    try{
      List<dynamic> followerUids = newPassiveUserDoc['followerUids'];
      final String newFollowerUid = currentUserDoc['uid'];
      followerUids.add(newFollowerUid);
      int followersCount = newPassiveUserDoc['followersCount'];
      followersCount += 1;
      await FirebaseFirestore.instance
      .collection('users')
      .doc(newPassiveUserDoc.id)
      .update({
        'followerUids': followerUids,
        'followersCount': followersCount,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future unfollow(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    followingUids.remove(passiveUserDoc['uid']);
    notifyListeners();
    final DocumentSnapshot newPassiveUserDoc = await getNewPassiveUserDoc(passiveUserDoc);
    await removeFollowingUidFromActiveUser(followingUids,currentUserDoc, newPassiveUserDoc);
    await removeFollowerUidOfPassiveUser(currentUserDoc, newPassiveUserDoc);
  }

  Future removeFollowingUidFromActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot newPassiveUserDoc) async {
    try{
      await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id)
      .update({
        'followingUids': followingUids,
      });
    } catch(e) {
      print(e.toString());
    } 
  }

  Future removeFollowerUidOfPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot newPassiveUserDoc) async {
    try{
      List<dynamic> followerUids = newPassiveUserDoc['followerUids'];
      followerUids.remove(currentUserDoc['uid']);
      int followersCount = newPassiveUserDoc['followersCount'];
      followersCount -= 1;
      await FirebaseFirestore.instance
      .collection('users')
      .doc(newPassiveUserDoc.id)
      .update({
        'followerUids': followerUids,
        'followersCount': followersCount,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future getNewPassiveUserDoc(DocumentSnapshot passiveUserDoc) async {
    final DocumentSnapshot newPassiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDoc.id)
    .get();
    return newPassiveUserDoc;
  }
}