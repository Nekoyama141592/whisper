// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/rounded_button.dart';
// model
import 'package:whisper/main_model.dart';

class FollowOrEditButton extends StatelessWidget {
  
  const FollowOrEditButton({
    Key? key,
    required this.mainModel,
    required this.userDoc,
    required this.followingUids,
    required this.onEditButtonPressed
  }) : super(key: key);

  final MainModel mainModel;
  final DocumentSnapshot<Map<String,dynamic>> userDoc;
  final List followingUids;
  final void Function()? onEditButtonPressed;
  @override 
  Widget build(BuildContext context) {
    final verticalPadding = 12.0;
    final manyUpdateUser = fromMapToManyUpdateUser(manyUpdateUserMap: userDoc.data()!);

    return userDoc.id == mainModel.currentWhisperUser.uid ?
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
    : !followingUids.contains(manyUpdateUser.uid) ?
    RoundedButton(
      text: 'follow', 
      widthRate: 0.35,
      verticalPadding: verticalPadding,
      horizontalPadding: 10.0,
      press: () async {
        try {
          await voids.follow(context, mainModel, userDoc);
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
          await voids.unfollow(mainModel, userDoc);
        } catch(e) {
          print(e.toString());          
        }
      },  
      textColor: Colors.white, 
      buttonColor: Theme.of(context).colorScheme.secondary
    );
    
  }
}