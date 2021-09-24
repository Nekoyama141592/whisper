import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/comments/comments_model.dart';
import 'package:whisper/parts/comments/components/comment_card.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/nothing.dart';

class Comments extends ConsumerWidget {
  Comments(this.currentSongCommentsNotifer);
  final ValueNotifier<List<dynamic>> currentSongCommentsNotifer;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _commentsProvider = watch(commentsProvider);
    return _commentsProvider.isLoading ?
    Loading()
    // : _commentsProvider.commentList.isEmpty ?
    : currentSongCommentsNotifer.value.isNotEmpty ?
    ValueListenableBuilder(
      valueListenable: currentSongCommentsNotifer, 
      builder: (_,currentSongComments,__){
        return
        Expanded(
          child: ListView.builder(
            itemCount: currentSongCommentsNotifer.value.length,
            itemBuilder: (BuildContext context, int i) =>
            CommentCard(currentSongCommentsNotifer.value[i])
          ),
        );

      }
    )
    : Nothing();
  }
}