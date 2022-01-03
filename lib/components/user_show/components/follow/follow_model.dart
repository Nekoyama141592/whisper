// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/others.dart';


final followProvider = ChangeNotifierProvider(
  (ref) => FollowModel()
);
class FollowModel extends ChangeNotifier {

  Future follow(BuildContext context,List<dynamic> followingUids,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,DocumentSnapshot<Map<String,dynamic>> passiveUserDoc) async {
    if (followingUids.length >= 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('フォローできるのは500人までです')));
    } else {
      followingUids.add(passiveUserDoc['uid']);
      notifyListeners();
      await updateFollowingUidsOfCurrentUser(followingUids, currentUserDoc, passiveUserDoc);
      await followerChildRef(passiveUid: passiveUserDoc.id, followerUid: currentUserDoc.id).set({
        'createdAt': Timestamp.now(),
        'followerUid': currentUserDoc.id,
      });
    }
  }

  Future unfollow(List<dynamic> followingUids,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,DocumentSnapshot<Map<String,dynamic>> passiveUserDoc) async {
    followingUids.remove(passiveUserDoc['uid']);
    notifyListeners();
    await updateFollowingUidsOfCurrentUser(followingUids, currentUserDoc, passiveUserDoc);
    await followerChildRef(passiveUid: passiveUserDoc.id, followerUid: currentUserDoc.id).delete();
  }

  Future updateFollowingUidsOfCurrentUser(List<dynamic> followingUids,DocumentSnapshot<Map<String,dynamic>> currentUserDoc,DocumentSnapshot<Map<String,dynamic>> passiveUserDoc) async {
    await FirebaseFirestore.instance.collection('users').doc(currentUserDoc.id).update({
      'followingUids': followingUids,
    });
  }
}