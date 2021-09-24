import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:whisper/components/bookmarks/bookmarks_model.dart';
import 'package:whisper/components/bookmarks/components/post_screen.dart';
class BookmarksPage extends ConsumerWidget {
  BookmarksPage(this.currentUserDoc,this.preservatedPostIds,this.likedPostIds);
  final DocumentSnapshot currentUserDoc;
  final List preservatedPostIds;
  final List likedPostIds;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _bookmarksProvider = watch(bookmarksProvider);
    return Scaffold(
      body: PostScreen(
        bookmarksProvider: _bookmarksProvider,
        currentUserDoc: currentUserDoc, 
        preservatedPostIds: preservatedPostIds, 
        likedPostIds: likedPostIds
      )
    );
  }
}

