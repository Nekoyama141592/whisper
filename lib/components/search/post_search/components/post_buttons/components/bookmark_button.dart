// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/components/search/post_search/components/post_buttons/posts_futures.dart';

class BookmarkButton extends ConsumerWidget {
  
  const BookmarkButton({
    Key? key,
    required this.currentUserDoc,
    required this.currentSongMapNotifier,
    required this.bookmarkedPostIds,
    required this.bookmarks
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  final List bookmarkedPostIds;
  final List bookmarks;

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_, currentSongMap, __) {
        return 
        bookmarkedPostIds.contains(currentSongMap['postId']) ?
        IconButton(
          icon: Icon(
            Icons.bookmark,
            color: Colors.red,
          ),
          onPressed: () async {
            await postFuturesModel.unbookmark(bookmarkedPostIds, currentUserDoc, currentSongMap, bookmarks);
          }, 
        )
        : IconButton(
          icon: Icon(Icons.bookmark_border),
          onPressed: () async {
            await postFuturesModel.bookmark(bookmarkedPostIds, currentUserDoc, currentSongMap, bookmarks);
          }, 
        );
      }
    );
    
  }
}