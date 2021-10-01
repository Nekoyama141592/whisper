// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/posts/components/post_buttons/components/comment_button.dart';
import 'package:whisper/posts/components/post_buttons/components/edit_button.dart';

class PostButtons extends StatelessWidget {

  PostButtons(
    this.currentUserDoc,
    this.currentSongDocNotifier,
    this.preservatedPostIds,
    this.likedPostIds
  );
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LikeButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, likedPostIds: likedPostIds),
        BookmarkButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, preservatedPostIds: preservatedPostIds),
        CommentButton(currentSongDocId: currentSongDocNotifier.value!.id, currentPostComments: currentSongDocNotifier.value!['comments']),
        EditButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier)
      ],
    );
  }
}