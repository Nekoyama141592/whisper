import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/posts/post_buttons/posts_futures.dart';

class CommentButton extends ConsumerWidget {

  CommentButton(this.uid,this.currentSongPostId);
  final String uid;
  final String currentSongPostId;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postsFeaturesProvider = watch(postsFeaturesProvider);
    final commentEditingController = TextEditingController();

    return IconButton(
      icon: Icon(Icons.comment),
      onPressed: () {
        showDialog(
          context: context, 
          builder: (_) {
            return AlertDialog(
              title: Text('comment'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: [
                    Container(
                      child: TextField(
                        controller: commentEditingController,
                        onChanged: (text) {
                          _postsFeaturesProvider.comment = text;
                        },
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('cancel'),
                  onPressed: (){
                    Navigator.pop(context);
                  }, 
                ),
                ElevatedButton(
                  child: Text('送信'),
                  onPressed: ()async {
                    await _postsFeaturesProvider.makeComment(
                      context,
                      uid, 
                      currentSongPostId
                    );
                    
                  }, 
                )
              ],
            );
          }
        );
      }, 
    );
  }
}