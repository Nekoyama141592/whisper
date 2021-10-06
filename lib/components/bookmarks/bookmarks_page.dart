// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/components/bookmarks/components/post_screen.dart';
// model
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

class BookmarksPage extends ConsumerWidget {
  
  const BookmarksPage({
    Key? key,
    required this.currentUserDoc,
    required this.bookmarkedPostIds,
    required this.likedPostIds,
    required this.likedCommentIds,
    required this.likedComments,
    required this.bookmarks,
    required this.likes
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List likedCommentIds;
  final List likedComments;
  final List bookmarks;
  final List likes;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final bookmarksModel = watch(bookmarksProvider);
    return Scaffold(
      body: PostScreen(
        bookmarksModel: bookmarksModel,
        currentUserDoc: currentUserDoc, 
        bookmarkedPostIds: bookmarkedPostIds, 
        likedPostIds: likedPostIds,
        likedCommentIds: likedCommentIds,
        likedComments: likedComments,
        bookmarks: bookmarks,
        likes: likes,
      )
    );
  }
}

