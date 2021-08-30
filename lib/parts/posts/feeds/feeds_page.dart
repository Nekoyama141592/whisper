import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/posts_model.dart';
import 'package:whisper/parts/posts/audio_state_design.dart';


class FeedsPage extends StatelessWidget {
  const FeedsPage({
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
    : _postsProvider.feedDocuments.isEmpty ?
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Nothing')
        )
      ],
    )
    : ListView.builder(
      itemCount: _postsProvider.feedDocuments.length,
      itemBuilder: (BuildContext context, int i) =>
        ListTile(
          title: Text(_postsProvider.feedDocuments[i]['title']),
        )
    );
  }
}