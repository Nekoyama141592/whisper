import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';
import 'package:whisper/parts/posts/post_buttons/components/preservate_button.dart';

class PostButtons extends StatelessWidget {

  PostButtons(this.uid,this.postDoc,this.preservatedPostIds);
  final String uid;
  final DocumentSnapshot postDoc;
  final List preservatedPostIds;
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(uid, postDoc),
        PreservateButton(uid, postDoc,preservatedPostIds)
      ],
    );
  }
}