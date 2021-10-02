// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/user_show_button.dart';
// models
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class UserShowHeader extends StatelessWidget {

  const UserShowHeader({
    Key? key,
    required this.userShowModel,
    required this.passiveUserDoc,
    required this.currentUserDoc,
    required this.followingUids,
    required this.followerUids,
    required this.followModel
  }) : super(key: key);

  final UserShowModel userShowModel;
  final DocumentSnapshot passiveUserDoc;
  final DocumentSnapshot currentUserDoc;
  final List followingUids;
  final List followerUids;
  final FollowModel followModel;
  @override 
  Widget build(BuildContext context) {
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
          Text(
            !userShowModel.isEdited ? passiveUserDoc['userName'] : userShowModel.userName,
            style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          Row(
            children: [
              UserImage(userImageURL: passiveUserDoc['imageURL'],length: 60.0,padding: 5.0,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  !userShowModel.isEdited ? passiveUserDoc['description'] : userShowModel.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              UserShowButton(
                currentUserDoc: currentUserDoc, 
                userDoc: passiveUserDoc, 
                userShowProvider: userShowModel, 
                followingUids: followingUids, 
                followProvider: followModel
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Text(
                'following' + followingUids.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 20,),
              Text(
                'follower' + followerUids.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(width: 20,),
            ],
          )
        ],
      ),
    );
  }
}