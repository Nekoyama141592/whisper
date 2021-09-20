import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/comments/comments_model.dart';
import 'package:whisper/parts/comments/components/comment_card.dart';
import 'package:whisper/parts/components/loading.dart';
import 'package:whisper/parts/components/nothing.dart';

class Comments extends ConsumerWidget {
  Comments(this.currentSongComments);
  final List<dynamic> currentSongComments;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _commentsProvider = watch(commentsProvider);
    return _commentsProvider.isLoading ?
    Loading()
    // : _commentsProvider.commentList.isEmpty ?
    : currentSongComments.isNotEmpty ?
    Expanded(
      child: ListView.builder(
        itemCount: currentSongComments.length,
        itemBuilder: (BuildContext context,int i) =>
        CommentCard(currentSongComments[i])
      ),
    )
    : Nothing();
  }
}