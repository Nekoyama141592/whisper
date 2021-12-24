// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/user_show/components/follow/follow_model.dart';
import 'package:whisper/details/rounded_button.dart';

class FollowOrEditButton extends StatelessWidget {
  
  const FollowOrEditButton({
    Key? key,
    required this.currentUserDoc,
    required this.userDoc,
    required this.followingUids,
    required this.followModel,
    required this.onEditButtonPressed
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot userDoc;
  final List followingUids;
  final FollowModel followModel;
  final void Function()? onEditButtonPressed;
  @override 
  Widget build(BuildContext context) {
    final verticalPadding = 12.0;
    return userDoc.id == currentUserDoc.id ?
    // 変更
    RoundedButton(
      text: '編集', 
      widthRate: 0.25,
      verticalPadding: verticalPadding,
      horizontalPadding: 0.0,
      press: onEditButtonPressed,
      textColor: Colors.white, 
      buttonColor: Theme.of(context).highlightColor
    )
    : !followingUids.contains(userDoc['uid']) ?
    RoundedButton(
      text: 'follow', 
      widthRate: 0.35,
      verticalPadding: verticalPadding,
      horizontalPadding: 10.0,
      press: () async {
        try {
          await followModel.follow(context,followingUids, currentUserDoc, userDoc);
        } catch(e) {
          print(e.toString());          
        }
      }, 
      textColor: Colors.white, 
      buttonColor: Theme.of(context).highlightColor
    )
    : RoundedButton(
      text: 'unfollow', 
      widthRate: 0.35,
      verticalPadding: verticalPadding,
      horizontalPadding: 10.0,
      press: () async {
        try {
          await followModel.unfollow(followingUids, currentUserDoc, userDoc);
        } catch(e) {
          print(e.toString());          
        }
      },  
      textColor: Colors.white, 
      buttonColor: Theme.of(context).colorScheme.secondary
    );
    
  }
}