import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/comments/comments_model.dart';

class Comments extends ConsumerWidget {
  Comments(this.postId);
  final String postId;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _commentsProvider = watch(commentsProvider);
    return _commentsProvider.isLoading ?
    Text('Loading')
    : _commentsProvider.commentList.isEmpty ?
    ElevatedButton(
      child: Text('コメントを見る'),
      onPressed: () {
        _commentsProvider.onCommentsButtonPressed(postId);
      }, 
    )
    : Text('something');
  }
}