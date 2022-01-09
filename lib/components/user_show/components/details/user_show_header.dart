// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// costants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/follow_or_edit_button.dart';
import 'package:whisper/components/user_show/components/details/link_button.dart';
// other_pages
import 'package:whisper/components/user_show/components/other_pages/show_description_page.dart';
// models
import 'package:whisper/main_model.dart';

class UserShowHeader extends ConsumerWidget {

  const UserShowHeader({
    Key? key,
    required this.passiveUserDoc,
    required this.onEditButtonPressed,
    required this.backArrow,
    required this.mainModel,
  }) : super(key: key);

  final DocumentSnapshot<Map<String,dynamic>> passiveUserDoc;
  final void Function()? onEditButtonPressed;
  final Widget backArrow;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final followerCount = passiveUserDoc[followerCountKey];
    final plusOneCount = followerCount + 1;

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
                  passiveUserDoc[userNameKey],
                  style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,)
                ),
              ),
              SizedBox(width: 5.0),
              passiveUserDoc[isOfficialKey] ? Icon(Icons.verified) : SizedBox.shrink()
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              UserImage(
                userImageURL: passiveUserDoc[imageURLKey],
                length: 60.0,
                padding: 5.0,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDescriptionPage(description: passiveUserDoc[descriptionKey],) ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      passiveUserDoc[descriptionKey],
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
              FollowOrEditButton(mainModel: mainModel, userDoc: passiveUserDoc, followingUids: mainModel.followingUids, onEditButtonPressed: onEditButtonPressed)
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
                  // mainModel.followingUids contains myUid because of lib/components/home/feeds/feeds_model.dart
                  mainModel.currentUserDoc[uidKey] == passiveUserDoc[uidKey] ?  (mainModel.followingUids.length - 1).toString() + 'following' : passiveUserDoc[followerCountKey].toString() + 'following',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  mainModel.followingUids.contains(passiveUserDoc[uidKey]) ?
                  plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万follower' : plusOneCount.toString() + 'follower'
                  : followerCount >= 10000 ? (followerCount/1000.floor()/10).toString() + '万follower' : followerCount.toString() + 'follower',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                SizedBox(width: 20),
                if (passiveUserDoc[linkKey].isNotEmpty) LinkButton(
                  link: passiveUserDoc[linkKey]
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}