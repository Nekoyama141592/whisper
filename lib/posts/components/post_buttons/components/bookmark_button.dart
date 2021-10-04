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
    required this.bookmarkedPostIds
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List bookmarkedPostIds;
  
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
            Icons.inventory_2,
            color: Colors.red,
          ),
          onPressed: () async {
            bookmarkedPostIds.remove(currentSongDoc['postId']);
            postFuturesModel.reload();
            await postFuturesModel.unpreservate(currentUserDoc, currentSongDoc);
          }, 
        )
        : IconButton(
          icon: Icon(Icons.inventory_2),
          onPressed: () async {
            bookmarkedPostIds.add(currentSongDoc['postId']);
            postFuturesModel.reload();
            await postFuturesModel.bookmark(currentUserDoc, currentSongDoc);
          }, 
        );
      }
    );
    
  }
}