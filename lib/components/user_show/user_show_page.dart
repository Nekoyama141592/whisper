// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
import 'package:whisper/components/user_show/components/other_pages/edit_profile_screen.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class UserShowPage extends ConsumerWidget {
  
  const UserShowPage({
    Key? key,
    required this.passiveUserDoc,
    required this.mainModel
  });

  final DocumentSnapshot passiveUserDoc;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    
    final userShowModel = watch(userShowProvider);
    final followModel = watch(followProvider);
    List<dynamic> blocksIpv6AndUids = passiveUserDoc['blocksIpv6AndUids'];
    List<dynamic> passiveBlocksUids = [];
    blocksIpv6AndUids.forEach((blocksIpv6AndUid) {
      passiveBlocksUids.add(blocksIpv6AndUid['uid']);
    });

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: isDisplayShowPage(mutesUids: mainModel.mutesUids, blocksUids: mainModel.blocksUids, passiveBlocksUids: passiveBlocksUids, currentUserDoc: mainModel.currentUserDoc) ?
     Column(
       children: [
          Text('コンテンツを表示できません',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),),
          SizedBox(height: 20.0,),
          Text('あなたはこのユーザーをミュート、ブロック'),
          SizedBox(height: 20.0,),
          Text('もしくは相手にブロックされています')
       ],
     )
      : Container(
        child: userShowModel.isEditing ?
        SafeArea(
          child: EditProfileScreen(
            onCancelButtonPressed: () { userShowModel.onCancelButtonPressed(); },
            onSaveButtonPressed: () async {
              await userShowModel.onSaveButtonPressed(context,mainModel.currentUserDoc);
              await mainModel.regetCurrentUserDoc(mainModel.currentUserDoc.id);
            },
            showImagePicker: () async { await userShowModel.showImagePicker(); },
            onUserNameChanged: (text) {
              userShowModel.userName = text;
            },
            onDescriptionChanged: (text) {
              userShowModel.description = text;
            },
            onLinkChanged: (text) {
              userShowModel.link = text;
            },
            mainModel: mainModel,
          )
        )
        : GradientScreen(
          top: SizedBox.shrink(), 
          header: UserShowHeader(
            onEditButtonPressed: () {
              userShowModel.onEditButtonPressed(mainModel.currentUserDoc);
            },
            passiveUserDoc: passiveUserDoc, 
            backArrow: InkWell(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            mainModel: mainModel, 
            followModel: followModel
          ),
          content: UserShowPostScreen(userShowModel: userShowModel,mainModel: mainModel),
          circular: 35.0
        ),
      )
    );
  }
}

