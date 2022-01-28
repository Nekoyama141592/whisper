// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/domain/post/post.dart';

class TimestampDisplay extends StatelessWidget {

  const TimestampDisplay({
    Key? key,
    required this.currentSongMapNotifier
  }) : super(key: key);

  final ValueNotifier<Map<String,dynamic>> currentSongMapNotifier;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: currentSongMapNotifier, 
      builder: (_,currentSongMap,__) {
        final Post whisperPost = fromMapToPost(postMap: currentSongMap);
        final Timestamp createdAt = whisperPost.createdAt as Timestamp;
        final createdAtDate = createdAt.toDate();
        final createdAtYear = createdAtDate.year.toString();
        final createdAtMonth = createdAtDate.month.toString();
        final createdAtDay = createdAtDate.day.toString();
        final createdAtHour = createdAtDate.hour.toString();

        return
        Text(createdAtYear + "/" + createdAtMonth + "/" + createdAtDay + " " + createdAtHour + "時台に投稿");
      }
    );
  }
}