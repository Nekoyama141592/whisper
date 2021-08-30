import 'package:flutter/material.dart';
import 'package:whisper/parts/posts/posts_model.dart';

import 'package:whisper/parts/posts/audio_state_design.dart';

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
    : ListView.builder(
      itemCount: _postsProvider.recommenderDocuments.length,
      itemBuilder: (BuildContext context, int i) {
        return ListTile(
          title: Text(_postsProvider.recommenderDocuments[i]['title']),
          trailing: IconButton(
            icon: Icon(Icons.recommend),
            onPressed: (){}, 
          ),
        );
      }
    );
  }
}

