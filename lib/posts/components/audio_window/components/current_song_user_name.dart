// material
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:whisper/constants/doubles.dart';
// domain
import 'package:whisper/domain/post/post.dart';
import 'package:whisper/main_model.dart';

class CurrentSongUserName extends StatelessWidget {
  
  const CurrentSongUserName({
    Key? key,
    required this.whisperPost,
    required this.mainModel
  }) : super(key: key);

  final Post whisperPost;
  final MainModel mainModel;
  
  @override
  
  Widget build(BuildContext context) {
    return Text(
      mainModel.currentWhisperUser.uid == whisperPost.uid ?
      mainModel.currentWhisperUser.userName :
      whisperPost.userName,
      style: TextStyle(
        fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2
      ),
      overflow: TextOverflow.ellipsis,
    );
}
}