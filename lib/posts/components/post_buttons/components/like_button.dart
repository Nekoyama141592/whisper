// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// model
import 'package:whisper/posts/components/post_buttons/posts_futures.dart';

class LikeButton extends ConsumerWidget {
  
  const LikeButton({
    required this.currentUserDoc,
    required this.currentSongDocNotifier,
    required this.likedPostIds,
  });
  
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  final List likedPostIds;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final postFuturesModel = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        return
        likedPostIds.contains(currentSongDoc!['postId']) ?
        IconButton(
          icon: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          onPressed: (){}, 
        )
        : IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () async {
            likedPostIds.add(currentSongDoc['postId']);
            postFuturesModel.reload();
            await postFuturesModel.like(currentUserDoc, currentSongDoc);
          }, 
        );
      }
    );
  }
}