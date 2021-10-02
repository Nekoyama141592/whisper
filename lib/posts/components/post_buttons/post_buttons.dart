// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/posts/components/post_buttons/components/edit_button.dart';
import 'package:whisper/posts/components/post_buttons/components/like_button.dart';
import 'package:whisper/posts/components/post_buttons/components/bookmark_button.dart';
import 'package:whisper/posts/components/post_buttons/components/comment_button.dart';
import 'package:whisper/posts/components/other_pages/post_show/components/edit_post_info/edit_post_info_model.dart';

class PostButtons extends StatelessWidget {

  const PostButtons({
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.editPostInfoModel
  });

  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final EditPostInfoModel editPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LikeButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, likedPostIds: likedPostIds),
        BookmarkButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, preservatedPostIds: bookmarkedPostIds),
        CommentButton(currentSongDocId: currentSongDocNotifier.value!.id, currentPostComments: currentSongDocNotifier.value!['comments']),
        EditButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, editPostInfoModel: editPostInfoModel)
      ],
    );
  }
}