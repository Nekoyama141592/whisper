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
    required this.likedCommentIds,
    required this.likedComments,
    required this.bookmarks,
    required this.likes,
    required this.editPostInfoModel
  });

  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;
  final List bookmarks;
  final List likes;
  final EditPostInfoModel editPostInfoModel;
  
  @override  
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        LikeButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, likedPostIds: likedPostIds,likes: likes),
        BookmarkButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, bookmarkedPostIds: bookmarkedPostIds,bookmarks: bookmarks),
        CommentButton(likedCommentIds: likedCommentIds,likedComments: likedComments,currentSongDocNotifier: currentSongDocNotifier,currentUserDoc: currentUserDoc,),
        EditButton(currentUserDoc: currentUserDoc, currentSongDocNotifier: currentSongDocNotifier, editPostInfoModel: editPostInfoModel)
      ],
    );
  }
}