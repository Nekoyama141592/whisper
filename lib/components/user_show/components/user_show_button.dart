import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/components/user_show/components/follow/follow_model.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/details/rounded_button.dart';

import 'package:whisper/components/user_show/user_show_model.dart';

class UserShowButton extends StatelessWidget {
  
  const UserShowButton({
    Key? key,
    required this.currentUserDoc,
    required this.userDoc,
    required this.userShowProvider,
    required this.followingUids,
    required this.followProvider
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot userDoc;
  final UserShowModel userShowProvider;
  final List followingUids;
  final FollowModel followProvider;
  @override 
  Widget build(BuildContext context) {
    return userDoc.id == currentUserDoc.id ?
    // 変更
    RoundedButton(
      '編集', 
      0.35, 
      () {
        userShowProvider.isEditing = true;
        userShowProvider.reload();
      }, 
      Colors.white, 
      kTertiaryColor
    )
    : !followingUids.contains(userDoc['uid']) ?
    RoundedButton(
      'follow', 
      0.35, 
      () async {
        try {
          followingUids.add(userDoc['uid']);
          followProvider.reload();
          await followProvider.follow(followingUids, currentUserDoc, userDoc);
        } catch(e) {
          print(e.toString());          
        }
      }, 
      Colors.white, 
      kTertiaryColor
    )
    : RoundedButton(
      'unfollow', 
      0.35, 
      () async {
        try {
          followingUids.remove(userDoc['uid']);
          followProvider.reload();
          await followProvider.unfollow(followingUids, currentUserDoc, userDoc);
        } catch(e) {
          print(e.toString());          
        }
      },  
      Colors.white, 
      kQuaternaryColor
    );
    
  }
}