// material
import 'package:flutter/material.dart';
// package
import 'package:whisper/components/search/post_search/components/replys/search_replys_model.dart';

class ReplyLikeButton extends StatelessWidget {

  const ReplyLikeButton({
    Key? key,
    required this.searchReplysModel
  }) : super(key: key);

  final SearchReplysModel searchReplysModel;
  @override 
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {
        
      }, 
    );
  }
}