import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/parts/comments/comments_model.dart';

class CommentButton extends ConsumerWidget {

  CommentButton(this.uid,this.currentSongPostId);
  final String uid;
  final String currentSongPostId;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _commentsProvider = watch(commentsProvider);
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
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (text) {
                          _commentsProvider.comment = text;
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