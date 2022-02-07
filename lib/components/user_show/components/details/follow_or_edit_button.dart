// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/rounded_button.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'package:whisper/main_model.dart';

class FollowOrEditButton extends StatelessWidget {
  
  const FollowOrEditButton({
    Key? key,
    required this.mainModel,
    required this.passiveWhisperUser,
    required this.followingUids,
    required this.onEditButtonPressed
  }) : super(key: key);

  final MainModel mainModel;
  final WhisperUser passiveWhisperUser;
  final List followingUids;
  final void Function()? onEditButtonPressed;
  @override 
  Widget build(BuildContext context) {
    final verticalPadding = 12.0;
    final String passiveUid = passiveWhisperUser.uid;
    return passiveWhisperUser.uid == mainModel.currentWhisperUser.uid ?
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
    : !followingUids.contains(passiveWhisperUser.uid) ?
    RoundedButton(
      text: 'follow', 
      widthRate: 0.4,
      verticalPadding: verticalPadding,
      horizontalPadding: 10.0,
      press: () async {
        try {
          await voids.follow(context: context, mainModel: mainModel, passiveUid: passiveUid);
        } catch(e) {
          print(e.toString());          
        }
      }, 
      textColor: Colors.white, 
      buttonColor: Theme.of(context).highlightColor
    )
    : RoundedButton(
      text: 'unfollow', 
      widthRate: 0.4,
      verticalPadding: verticalPadding,
      horizontalPadding: 10.0,
      press: () async {
        try {
          await voids.unfollow(mainModel: mainModel, passiveUid: passiveUid);
        } catch(e) {
          print(e.toString());
        }
      },  
      textColor: Colors.white, 
      buttonColor: Theme.of(context).colorScheme.secondary
    );
    
  }
}