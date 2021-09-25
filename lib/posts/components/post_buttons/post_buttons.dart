import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/post_buttons/components/preservate_button.dart';
import 'package:whisper/posts/components/post_buttons/components/comment_button.dart';

class PostButtons extends StatelessWidget {

  PostButtons(
    this.currentUserDoc,
    this.currentSongPostIdNotifier,
    this.currentSongPostDocIdNotifier,
    this.currentSongCommentsNotifier,
    this.preservatedPostIds,
    this.likedPostIds
  );
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<String> currentSongPostIdNotifier;
  final ValueNotifier<String> currentSongPostDocIdNotifier;
  final ValueNotifier<List<dynamic>> currentSongCommentsNotifier;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(currentUserDoc, currentSongPostIdNotifier,likedPostIds),
        PreservateButton(currentUserDoc, currentSongPostIdNotifier,preservatedPostIds),
        CommentButton(currentSongPostDocIdNotifier.value,currentSongCommentsNotifier.value)
      ],
    );
  }
}