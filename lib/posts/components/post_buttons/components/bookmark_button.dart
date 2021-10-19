// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/posts/components/post_buttons/posts_futures.dart';

class BookmarkButton extends ConsumerWidget {
  
  const BookmarkButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.bookmarkedPostIds,
    required this.bookmarks
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List bookmarkedPostIds;
  final List bookmarks;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return 
        bookmarkedPostIds.contains(currentSongDoc!['postId']) ?
        IconButton(
          icon: Icon(
            Icons.bookmark,
            color: Theme.of(context).highlightColor,
          ),
          onPressed: () async {
            await postFuturesModel.unbookmark(bookmarkedPostIds, currentUserDoc, currentSongDoc, bookmarks);
          }, 
        )
        : IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () async {
            await postFuturesModel.bookmark(bookmarkedPostIds, currentUserDoc, currentSongDoc, bookmarks);
          }, 
        );
      }
    );
    
  }
}