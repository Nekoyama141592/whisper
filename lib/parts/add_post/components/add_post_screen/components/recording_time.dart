import 'package:flutter/material.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:whisper/parts/add_post/add_post_model.dart';

class RecordingTime extends StatelessWidget {
  @override 
  RecordingTime(this.addPostProvider,this.fontSize);
  final AddPostModel addPostProvider;
  final double? fontSize;
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: addPostProvider.stopWatchTimer.rawTime,
      initialData: addPostProvider.stopWatchTimer.rawTime.value,
      builder: (context,snapshot) {
        final value = snapshot.data!.toInt();
        if (value >= 60000) {
          addPostProvider.stopButtonPressed();
        }
        final displayTime = StopWatchTimer.getDisplayTime(
          value,
          hours: false,
          milliSecond: false,
        );
        return Text(
          displayTime,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold
          ),
        );
      }
    );
  }
}