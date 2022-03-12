// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/others.dart';
// model
import 'package:whisper/main_model.dart';

class UserCard extends StatelessWidget {

  const UserCard({
    Key? key,
    required this.result,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> result;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    final passiveWhisperUser = fromMapToWhisperUser(userMap: result);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(cardOpacity),
        ),
        borderRadius: BorderRadius.circular( defaultPadding(context: context) )
      ),
      child: ListTile(
        leading: RedirectUserImage(userImageURL: passiveWhisperUser.imageURL, length: defaultPadding(context: context) * 4.0, padding: 0.0,passiveUserDocId: passiveWhisperUser.uid,mainModel: mainModel,),
        trailing: Text(passiveWhisperUser.followerCount.toString() ,style: TextStyle(fontSize: defaultHeaderTextSize(context: context)),),
        title: Text(
          passiveWhisperUser.userName,
          style: TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2
          ),
        ),
        subtitle: Text(
          passiveWhisperUser.bio,
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontWeight: FontWeight.bold,
            fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}