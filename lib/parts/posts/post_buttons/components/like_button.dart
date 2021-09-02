import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/posts/post_buttons/posts_futures.dart';

class LikeButton extends ConsumerWidget {
  LikeButton(this.uid,this.postDoc,this.likedPostIds);
  final String uid;
  final DocumentSnapshot postDoc;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postFeaturesProvider = watch(postsFeaturesProvider);
    return likedPostIds.contains(postDoc['postId']) ?
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
        await _postFeaturesProvider.like(uid, postDoc);
        likedPostIds.add(postDoc['postId']);
        _postFeaturesProvider.reload();
      }, 
    );
  }
}