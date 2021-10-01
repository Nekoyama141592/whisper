// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/posts/components/comments/components/comment_card.dart';
// model
import 'package:whisper/posts/components/comments/comments_model.dart';

class Comments extends ConsumerWidget {
  
  const Comments({
    Key? key,
    required this.currentSongDocNotifier,
  }) : super(key: key);
  
  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final commentsModel = watch(commentsProvider);
    return commentsModel.isLoading ?
    Loading()
    : currentSongDocNotifier.value!['comments'].isNotEmpty ?
    ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_, currentSongDoc, __) {
        final List<dynamic> comments = currentSongDocNotifier.value!['comments'];
        return
        Expanded(
          child: ListView.builder(
            itemCount: comments.length,
            itemBuilder: (BuildContext context, int i) =>
            CommentCard(comment: comments[i])
          ),
        );

      }
    )
    : Nothing();
  }
}