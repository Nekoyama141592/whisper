// material
import 'package:flutter/material.dart';
// package
import 'package:whisper/posts/components/replys/replys_model.dart';

class ReplyLikeButton extends StatelessWidget {

  const ReplyLikeButton({
    Key? key,
    required this.replysModel
  }) : super(key: key);

  final ReplysModel replysModel;
  @override 
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.favorite),
      onPressed: () {
        
      }, 
    );
  }
}