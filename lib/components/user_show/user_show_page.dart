// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components

import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/components/user_show/components/details/user_show_header.dart';
import 'package:whisper/components/user_show/components/details/user_show_post_screen.dart';
import 'package:whisper/components/user_show/components/edit_profile/edit_profile_screen.dart';
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
    

    final List<dynamic> followerUids = mainModel.currentUserDoc['followerUids'];

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: userShowModel.isEditing ?
      SafeArea(child: EditProfileScreen(userShowModel: userShowModel, currentUserDoc: mainModel.currentUserDoc,mainModel: mainModel,))
      : GradientScreen(
        top: SizedBox.shrink(), 
        header: UserShowHeader(userShowModel: userShowModel, passiveUserDoc: passiveUserDoc, followerUids: followerUids, mainModel: mainModel, followModel: followModel),
        content: UserShowPostScreen(userShowModel: userShowModel, currentUserDoc: mainModel.currentUserDoc, mainModel: mainModel),
        circular: 35.0
      )
    );
  }
}

