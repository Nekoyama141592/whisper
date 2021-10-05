// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentReplyButton extends StatelessWidget {

  const CommentReplyButton({
    Key? key,
    required this.currentSongDoc,
    required this.comment
  }) : super(key: key);

  final DocumentSnapshot currentSongDoc;
  final Map<String,dynamic> comment;
  
  @override 
  Widget build(BuildContext context) {
    return comment['uid'] == currentSongDoc['uid'] ?
    Icon(Icons.mode_comment) : SizedBox.shrink();
  }
}