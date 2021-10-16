// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/components/user_show/components/details/user_show_button.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/global_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class UserShowHeader extends ConsumerWidget {

  const UserShowHeader({
    Key? key,
    required this.userShowModel,
    required this.passiveUserDoc,
    required this.followerUids,
   required this.mainModel,
   required this.followModel
  }) : super(key: key);

  final UserShowModel userShowModel;
  final DocumentSnapshot passiveUserDoc;
  final List followerUids;
  final MainModel mainModel;
  final FollowModel followModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final globalModel = watch(globalProvider);
    final followerCount = followerUids.length;
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
          ValueListenableBuilder<bool>(
            valueListenable: globalModel.isMyShowPageNotifier,
            builder: (_,value,__) {
              return value ?
              SizedBox.shrink()
              : Column(
                children: [
                  InkWell(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.pop(context);
                      globalModel.isMyShowPageNotifier.value = true;
                    },
                  ),
                  SizedBox(height: 10.0,)
                ],
              );
            }
          ),
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
              UserShowButton(
                currentUserDoc: mainModel.currentUserDoc, 
                userDoc: passiveUserDoc, 
                userShowModel: userShowModel, 
                followingUids: mainModel.followingUids, 
                followProvider: followModel
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
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
              SizedBox(width: 20,),
            ],
          )
        ],
      ),
    );
  }
}