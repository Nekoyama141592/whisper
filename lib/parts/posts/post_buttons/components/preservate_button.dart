import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/posts/post_buttons/posts_futures.dart';

class PreservateButton extends ConsumerWidget {
  PreservateButton(this.currentUserDoc,this.postDoc,this.preservatedPostIds);
  final DocumentSnapshot currentUserDoc;
  final DocumentSnapshot postDoc;
  final List preservatedPostIds;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postsFeaturesProvider = watch(postsFeaturesProvider);
    return preservatedPostIds.contains(postDoc.id) ?
    IconButton(
      icon: Icon(
        Icons.inventory_2,
        color: Colors.red,
      ),
      onPressed: (){}, 
    )
    : IconButton(
      icon: Icon(Icons.inventory_2),
      onPressed: () async {
        await _postsFeaturesProvider.preservate(currentUserDoc, postDoc);
        preservatedPostIds.add(postDoc.id);
        _postsFeaturesProvider.reload();
      }, 
    );
  }
}