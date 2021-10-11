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
            !userShowModel.isEdited ? passiveUserDoc['userName'] : userShowModel.userName,
            style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 10),
          Row(
            children: [
              UserImage(
                userImageURL: !userShowModel.isEdited ? passiveUserDoc['imageURL'] : userShowModel.downloadURL,
                length: 60.0,
                padding: 5.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    !userShowModel.isEdited ? passiveUserDoc['description'] : userShowModel.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
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
                'following' + mainModel.followingUids.length.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
                ),
              ),
              SizedBox(width: 20,),
              Text(
                'follower' + followerUids.length.toString(),
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