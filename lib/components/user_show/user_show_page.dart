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
import 'package:whisper/components/user_show/user_show_model.dart';
import 'package:whisper/components/user_show/components/follow/follow_model.dart';

class UserShowPage extends ConsumerWidget {
  
  const UserShowPage({
    Key? key,
    required this.currentUserDoc,
    required this.passiveUserDoc,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.followingUids
  });

  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot passiveUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List followingUids;
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userShowModel = watch(userShowProvider);
    final followModel = watch(followProvider);
    final List<dynamic> followerUids = currentUserDoc['followerUids'];

    return Scaffold(
      extendBodyBehindAppBar: false,
      body: userShowModel.isEditing ?
      SafeArea(child: EditProfileScreen(userShowModel: userShowModel, currentUserDoc: currentUserDoc))
      : GradientScreen(
        top: SizedBox.shrink(), 
        header: UserShowHeader(userShowModel: userShowModel, passiveUserDoc: passiveUserDoc, currentUserDoc: currentUserDoc, followingUids: followingUids, followerUids: followerUids, followModel: followModel), 
        content: UserShowPostScreen(userShowModel: userShowModel, currentUserDoc: currentUserDoc, bookmarkedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds), 
        circular: 35.0
      )
    );
  }
}

