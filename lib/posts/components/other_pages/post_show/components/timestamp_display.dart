// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampDisplay extends StatelessWidget {

  const TimestampDisplay({
    Key? key,
    required this.currentSongDocNotifier
  }) : super(key: key);

  final ValueNotifier<DocumentSnapshot?> currentSongDocNotifier;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DocumentSnapshot?>(
      valueListenable: currentSongDocNotifier, 
      builder: (_,currentSongDoc,__) {
        
        final Timestamp createdAt = currentSongDoc!['createdAt'];
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