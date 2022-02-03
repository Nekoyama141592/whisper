// material
import 'package:flutter/material.dart';
// package
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/follow_or_edit_button.dart';
import 'package:whisper/components/user_show/components/details/link_button.dart';
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// other_pages
import 'package:whisper/components/user_show/components/other_pages/show_description_page.dart';
// models
import 'package:whisper/main_model.dart';

class UserShowHeader extends StatelessWidget {

  const UserShowHeader({
    Key? key,
    required this.passiveWhisperUser,
    required this.onEditButtonPressed,
    required this.backArrow,
    required this.mainModel,
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;
  final void Function()? onEditButtonPressed;
  final Widget backArrow;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {

    final followerCount = passiveWhisperUser.followerCount;
    final plusOneCount = followerCount + 1;
    final List<WhisperLink> whisperLinks = passiveWhisperUser.links.map((link){
      return fromMapToWhisperLink(whisperLink: link);
    }).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20.0, 
        20.0, 
        20.0, 
        5.0
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          backArrow,
          SizedBox(height: 10.0,),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Text(
                  passiveWhisperUser.userName,
                  style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,)
                ),
              ),
              SizedBox(width: 5.0),
              passiveWhisperUser.isOfficial ? Icon(Icons.verified) : SizedBox.shrink()
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              UserImage(
                userImageURL: passiveWhisperUser.imageURL,
                length: 60.0,
                padding: 5.0,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDescriptionPage(description: passiveWhisperUser.description ) ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      passiveWhisperUser.description,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              FollowOrEditButton(mainModel: mainModel, passiveWhisperUser: passiveWhisperUser, followingUids: mainModel.followingUids, onEditButtonPressed: onEditButtonPressed)
            ],
          ),
          SizedBox(height: 16),
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
                    fontSize: 16.0
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  mainModel.followingUids.contains(passiveWhisperUser.uid) ?
                  plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万follower' : plusOneCount.toString() + 'follower'
                  : followerCount >= 10000 ? (followerCount/1000.floor()/10).toString() + '万follower' : followerCount.toString() + 'follower',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                  ),
                ),
                SizedBox(width: 20),
                Icon(Icons.search),
                Icon(Icons.link),
                if (whisperLinks.isNotEmpty) LinkButton(
                  link: whisperLinks.first.link
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}