import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/posts/post_buttons/posts_futures.dart';

class LikeButton extends ConsumerWidget {
  LikeButton(
    this.currentUserDoc,
    this.currentSongPostIdNotifier,
    this.likedPostIds,
  );
  final DocumentSnapshot currentUserDoc;
  final ValueNotifier<String> currentSongPostIdNotifier;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postFeaturesProvider = watch(postsFeaturesProvider);
    return 
    ValueListenableBuilder(
      valueListenable: currentSongPostIdNotifier, 
      builder: (_,currentSongPostId,__){
        return
        likedPostIds.contains(currentSongPostId) ?
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
            likedPostIds.add(currentSongPostId);
            _postFeaturesProvider.reload();
            // await _postFeaturesProvider.like(currentUserDoc, postDoc);
          }, 
        );
      }
    );
  }
}