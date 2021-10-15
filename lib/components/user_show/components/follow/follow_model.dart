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
      await addFollowingUidToActiveUser(followingUids,currentUserDoc, passiveUserDoc);
      final DocumentSnapshot newPassiveUserDoc = await getNewPassiveUserDoc(passiveUserDoc);
      await addFollowerUidToPassiveUser(currentUserDoc, newPassiveUserDoc);
    }
  }

  Future unfollow(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    await removeFollowingUidOfActiveUser(followingUids,currentUserDoc, passiveUserDoc);
    await removeFollowerUidOfPassiveUser(currentUserDoc, passiveUserDoc);
  }
  
  Future addFollowingUidToActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
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

  Future addFollowerUidToPassiveUser(DocumentSnapshot currentUserDoc,DocumentSnapshot newPassiveUserDoc) async {
    try{
      final List<dynamic> followerUids = newPassiveUserDoc['followerUids'];
      final String newFollowerUid = currentUserDoc['uid'];
      followerUids.add(newFollowerUid);
      await FirebaseFirestore.instance
      .collection('users')
      .doc(newPassiveUserDoc.id)
      .update({
        'followerUids': followerUids,
      });
    } catch(e) {
      print(e.toString());
    }
  }

  Future removeFollowingUidOfActiveUser(List<dynamic> followingUids,DocumentSnapshot currentUserDoc,DocumentSnapshot passiveUserDoc) async {
    try{
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

  Future getNewPassiveUserDoc(DocumentSnapshot passiveUserDoc) async {
    final DocumentSnapshot newPassiveUserDoc = await FirebaseFirestore.instance
    .collection('users')
    .doc(passiveUserDoc.id)
    .get();
    return newPassiveUserDoc;
  }
}