// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/user_show/components/follow/follow_model.dart';
import 'package:whisper/details/rounded_button.dart';
// model
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
      0.25,
      20,
      0,
      () {
        userShowProvider.onEditButtonPressed(currentUserDoc);
      }, 
      Colors.white, 
      Theme.of(context).highlightColor
    )
    : !followingUids.contains(userDoc['uid']) ?
    RoundedButton(
      'follow', 
      0.35,
      20,
      10,
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
      Theme.of(context).highlightColor
    )
    : RoundedButton(
      'unfollow', 
      0.35,
      20,
      10, 
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
      Theme.of(context).colorScheme.secondary
    );
    
  }
}