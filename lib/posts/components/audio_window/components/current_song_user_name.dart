// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/constants/doubles.dart';
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
        fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2
      ),
      overflow: TextOverflow.ellipsis,
    );
}
}