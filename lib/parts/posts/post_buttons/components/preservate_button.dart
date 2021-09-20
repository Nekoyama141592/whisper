import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/posts/post_buttons/posts_futures.dart';

class PreservateButton extends ConsumerWidget {
  PreservateButton(this.currentUserDoc,this.currentSongPostId,this.preservatedPostIds);
  final DocumentSnapshot currentUserDoc;
  final String currentSongPostId;
  final List preservatedPostIds;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postsFeaturesProvider = watch(postsFeaturesProvider);
    return preservatedPostIds.contains(currentSongPostId) ?
    IconButton(
      icon: Icon(
        Icons.inventory_2,
        color: Colors.red,
      ),
      onPressed: () async {
        preservatedPostIds.remove(currentSongPostId);
        _postsFeaturesProvider.reload();
        // await _postsFeaturesProvider.unpreservate(currentUserDoc, postDoc);
      }, 
    )
    : IconButton(
      icon: Icon(Icons.inventory_2),
      onPressed: () async {
        preservatedPostIds.add(currentSongPostId);
        _postsFeaturesProvider.reload();
        // await _postsFeaturesProvider.preservate(currentUserDoc, postDoc);
      }, 
    );
  }
}