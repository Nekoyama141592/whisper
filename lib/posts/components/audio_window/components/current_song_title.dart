// material
import 'package:flutter/cupertino.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/domain/post/post.dart';

class CurrentSongTitle extends StatelessWidget {
  
  const CurrentSongTitle({
    Key? key,
    required this.whisperPost
  }) : super(key: key);
  
  final Post whisperPost;
  
  @override  
  Widget build(BuildContext context) {
   return Text(
    whisperPost.title,
    style: TextStyle(
      fontSize: defaultHeaderTextSize(context: context)/cardTextDiv2,
      fontWeight: FontWeight.bold
    ),
    overflow: TextOverflow.ellipsis,
  );
  }
}