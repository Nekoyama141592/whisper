// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/follow_or_edit_button.dart';
import 'package:whisper/components/user_show/components/details/link_button.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// other_pages
import 'package:whisper/components/user_show/components/other_pages/show_bio/show_bio_page.dart';
// models
import 'package:whisper/main_model.dart';

class UserShowHeader extends ConsumerWidget {

  const UserShowHeader({
    Key? key,
    required this.passiveWhisperUser,
    required this.onEditButtonPressed,
    required this.onMenuPressed,
    required this.backArrow,
    required this.mainModel,
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;
  final void Function()? onEditButtonPressed;
  final void Function()? onMenuPressed;
  final Widget backArrow;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context, WidgetRef ref ) {

    final followerCount = passiveWhisperUser.followerCount;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        defaultPadding(context: context), 
        defaultPadding(context: context), 
        defaultPadding(context: context), 
        defaultPadding(context: context)/3.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backArrow,
          SizedBox(height: defaultPadding(context: context),),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  passiveWhisperUser.userName,
                  style: TextStyle(color: Colors.white, fontSize: defaultHeaderTextSize(context: context),fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,)
                ),
              ),
              SizedBox(width: defaultPadding(context: context)/3.0),
              passiveWhisperUser.isOfficial ? Icon(Icons.verified) : SizedBox.shrink()
            ],
          ),
          SizedBox(height: defaultPadding(context: context) ),
          Row(
            children: [
              UserImage(
                userImageURL: passiveWhisperUser.userImageURL,
                length: defaultPadding(context: context) * 4.0,
                padding: defaultPadding(context: context),
                uid: passiveWhisperUser.uid,
                mainModel: mainModel,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDescriptionPage( mainModel: mainModel,passiveWhisperUser: passiveWhisperUser, ) ));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding(context: context)),
                    child: Text(
                      passiveWhisperUser.bio,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: defaultHeaderTextSize(context: context),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              FollowOrEditButton(mainModel: mainModel, passiveWhisperUser: passiveWhisperUser, followingUids: mainModel.followingUids, onEditButtonPressed: onEditButtonPressed)
            ],
          ),
          SizedBox(height: defaultPadding(context: context) ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  // mainModel.followingUids contains myUid because of lib/main_model.dart
                  mainModel.currentWhisperUser.uid == passiveWhisperUser.uid ?  (mainModel.followingUids.length - 1).toString() + 'following' : passiveWhisperUser.followingCount.toString() + 'following',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: defaultHeaderTextSize(context: context)/1.2,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: defaultPadding(context: context),),
                Text(
                  returnJaInt(count: followerCount),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: defaultHeaderTextSize(context: context)/1.2,
                    overflow: TextOverflow.ellipsis
                  ),
                ),
                SizedBox(width: defaultPadding(context: context) ),
                InkWell(
                  child: Icon(Icons.menu),
                  onTap: onMenuPressed,
                ),
                if (passiveWhisperUser.links.isNotEmpty) LinkButton(passiveWhisperUser: passiveWhisperUser)
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}