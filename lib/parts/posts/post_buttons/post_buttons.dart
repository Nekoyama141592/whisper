import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/parts/posts/post_buttons/components/like_button.dart';
import 'package:whisper/parts/posts/post_buttons/components/preservate_button.dart';
import 'package:whisper/parts/posts/post_buttons/components/comment_button.dart';

class PostButtons extends StatelessWidget {

  PostButtons(this.uid,this.postDoc,this.preservatedPostIds,this.likedPostIds);
  final String uid;
  final DocumentSnapshot postDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(uid, postDoc,likedPostIds),
        PreservateButton(uid, postDoc,preservatedPostIds),
        CommentButton(uid,postDoc)
      ],
    );
  }
}