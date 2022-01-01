import 'package:flutter/material.dart';

import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'package:whisper/components/add_post/add_post_model.dart';

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
          addPostProvider.stopMeasure();
          addPostProvider.audioRecorder.stop();
        }
        final displayTime = StopWatchTimer.getDisplayTime(
          value,
          hours: false,
          milliSecond: false,
        );
        return Column(
          children: [
            Text(
              displayTime,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold
              ),
            ),
            Text('(Max 1:00)',style: TextStyle(fontSize: fontSize!/2.5,),)
          ],
        );
      }
    );
  }
}