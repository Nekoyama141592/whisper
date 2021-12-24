// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/follow/follow_or_edit_button.dart';
import 'package:whisper/components/user_show/components/details/link_button.dart';
// other_pages
import 'package:whisper/components/user_show/components/other_pages/show_description_page.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class UserShowHeader extends ConsumerWidget {

  const UserShowHeader({
    Key? key,
    required this.passiveUserDoc,
    required this.onEditButtonPressed,
    required this.backArrow,
   required this.mainModel,
   required this.followModel
  }) : super(key: key);

  final DocumentSnapshot passiveUserDoc;
  final void Function()? onEditButtonPressed;
  final Widget backArrow;
  final MainModel mainModel;
  final FollowModel followModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final followerCount = passiveUserDoc['followersCount'];
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
          Text(
            passiveUserDoc['userName'],
            style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,)
          ),
          SizedBox(height: 10),
          Row(
            children: [
              UserImage(
                userImageURL: passiveUserDoc['imageURL'],
                length: 60.0,
                padding: 5.0,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShowDescriptionPage(description: passiveUserDoc['description'],) ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      passiveUserDoc['description'],
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
              FollowOrEditButton(
                currentUserDoc: mainModel.currentUserDoc, 
                userDoc: passiveUserDoc, 
                followingUids: mainModel.followingUids, 
                followModel: followModel,
                onEditButtonPressed: onEditButtonPressed,
              ),
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
                  mainModel.currentUserDoc['uid'] == passiveUserDoc['uid'] ?  mainModel.followingUids.length.toString() + 'following' : passiveUserDoc['followingUids'].length.toString() + 'following',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                SizedBox(width: 20,),
                Text(
                  mainModel.followingUids.contains(passiveUserDoc['uid']) ?
                  plusOneCount >= 10000 ? (plusOneCount/1000.floor()/10).toString() + '万follower' : plusOneCount.toString() + 'follower'
                  : followerCount >= 10000 ? (followerCount/1000.floor()/10).toString() + '万follower' : followerCount.toString() + 'follower',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
                ),
                SizedBox(width: 20),
                if (passiveUserDoc['link'].isNotEmpty) LinkButton(
                  link: passiveUserDoc['link']
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}