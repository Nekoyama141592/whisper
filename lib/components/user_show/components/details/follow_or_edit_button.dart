// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/rounded_button.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';

class FollowOrEditButton extends ConsumerWidget {
  
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
  Widget build(BuildContext context,WidgetRef ref ) {
    
    final String passiveUid = passiveWhisperUser.uid;
    final userShowModel = ref.watch(userShowProvider);
    final double withRate = 0.4;
    final fontSize = defaultHeaderTextSize(context: context)/1.25;
    return passiveWhisperUser.uid == mainModel.currentWhisperUser.uid ?

    // 変更
    RoundedButton(
      text: '編集', 
      fontSize: fontSize,
      widthRate: withRate,
      press: onEditButtonPressed,
      textColor: Colors.white, 
      buttonColor: Theme.of(context).highlightColor
    )
    : !followingUids.contains(passiveWhisperUser.uid) ?
    RoundedButton(
      text: 'follow',
      fontSize: fontSize, 
      widthRate: withRate,
      press: () async {
        await userShowModel.follow(context: context, mainModel: mainModel, passiveUid: passiveUid);
      }, 
      textColor: Colors.white, 
      buttonColor: Theme.of(context).highlightColor
    )
    : RoundedButton(
      text: 'unfollow',
      fontSize: fontSize, 
      widthRate: withRate,
      press: () async {
        await userShowModel.unfollow(mainModel: mainModel, passiveUid: passiveUid);
      },  
      textColor: Colors.white, 
      buttonColor: Theme.of(context).colorScheme.secondary
    );
    
  }
}