import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/posts_model.dart';

class CurrentSongTitle extends StatelessWidget {
  const CurrentSongTitle({
    Key? key,
    required PostsModel postsProvider,
  }) : _postsProvider = postsProvider, super(key: key);

  final PostsModel _postsProvider;
  @override  
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      // child: Text(_postsProvider.currentSongDoc.id, style: TextStyle(fontSize: 20)),
      // child: Text(_postsProvider.currentSongDoc['title'], style: TextStyle(fontSize: 20)),
      child: Text(_postsProvider.currentSongDoc['title']),
    );
  }
}