// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// domain
import 'package:whisper/domain/post/post.dart';

class CurrentSongUserName extends StatelessWidget {
  
  const CurrentSongUserName({
    Key? key,
    required this.whisperPost
  }) : super(key: key);

  final Post whisperPost;
  
  @override
  
  Widget build(BuildContext context) {
    return Text(
      whisperPost.userName,
      style: TextStyle(
        fontSize: 20
      ),
      overflow: TextOverflow.ellipsis,
    );
}
}