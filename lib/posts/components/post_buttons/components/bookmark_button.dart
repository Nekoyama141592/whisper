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
    required this.preservatedPostIds
  }) : super(key: key);
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List preservatedPostIds;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postsFeaturesProvider = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return 
        preservatedPostIds.contains(currentSongDoc!['postId']) ?
        IconButton(
          icon: Icon(
            Icons.inventory_2,
            color: Colors.red,
          ),
          onPressed: () async {
            preservatedPostIds.remove(currentSongDoc['postId']);
            _postsFeaturesProvider.reload();
            // await _postsFeaturesProvider.unpreservate(currentUserDoc, postDoc);
          }, 
        )
        : IconButton(
          icon: Icon(Icons.inventory_2),
          onPressed: () async {
            preservatedPostIds.add(currentSongDoc['postId']);
            _postsFeaturesProvider.reload();
            // await _postsFeaturesProvider.preservate(currentUserDoc, postDoc);
          }, 
        );
      }
    );
    
  }
}