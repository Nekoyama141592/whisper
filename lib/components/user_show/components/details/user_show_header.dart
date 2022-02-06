// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/components/user_show/components/other_pages/post_search/post_search_model.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/follow_or_edit_button.dart';
import 'package:whisper/components/user_show/components/details/link_button.dart';
// constants
import 'package:whisper/constants/routes.dart' as routes;
// domain
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// other_pages
import 'package:whisper/components/user_show/components/other_pages/show_description_page.dart';
// models
import 'package:whisper/main_model.dart';

class UserShowHeader extends ConsumerWidget {

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
  Widget build(BuildContext context, WidgetRef ref ) {

    final followerCount = passiveWhisperUser.followerCount;
    final plusOneCount = followerCount + 1;
    final PostSearchModel postSearchModel = ref.watch(postSearchProvider);

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
                userImageURL: passiveWhisperUser.imageURL,
                length: defaultPadding(context: context) * 4.0,
                padding: defaultPadding(context: context),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDescriptionPage(description: passiveWhisperUser.description ) ));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(defaultPadding(context: context)),
                    child: Text(
                      passiveWhisperUser.description,
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
                    fontSize: defaultHeaderTextSize(context: context)
                  ),
                ),
                SizedBox(width: defaultPadding(context: context),),
                Text(
                  mainModel.followingUids.contains(passiveWhisperUser.uid) ?
                  plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万follower' : plusOneCount.toString() + 'follower'
                  : followerCount >= 10000 ? (followerCount/1000.floor()/10).toString() + '万follower' : followerCount.toString() + 'follower',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: defaultHeaderTextSize(context: context)
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  child: Icon(Icons.search),
                  onTap: () {
                    routes.toPostSearchPage(context: context, passiveWhisperUser: passiveWhisperUser, mainModel: mainModel, postSearchModel: postSearchModel);
                  },
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