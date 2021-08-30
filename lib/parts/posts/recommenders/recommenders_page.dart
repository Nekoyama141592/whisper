import 'package:flutter/material.dart';
import 'package:whisper/parts/posts/posts_model.dart';

import 'package:whisper/parts/posts/post_card.dart';
class RecommendersPage extends StatelessWidget {
  const RecommendersPage({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;

  @override
  Widget build(BuildContext context) {
    return _postsProvider.isLoading ?
    Container(
      color: Colors.grey.withOpacity(0.7),
      child: Text('Loading'),
    )
    : PostCard(
      _postsProvider.recommenderDocuments, 
      _postsProvider,
    );
  }
}

