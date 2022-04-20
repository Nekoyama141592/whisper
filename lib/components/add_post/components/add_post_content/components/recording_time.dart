// material
import 'package:flutter/material.dart';
// package
import 'package:stop_watch_timer/stop_watch_timer.dart';
// constants
import 'package:whisper/constants/ints.dart';
// model
import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/widgets.dart';

class RecordingTime extends StatelessWidget {
  @override 
  RecordingTime({ Key? key,required this.addPostModel, required this.fontSize}) : super(key: key);
  final AddPostModel addPostModel;
  final double? fontSize;
  Widget build(BuildContext context) {
    return StreamBuilder<int?>(
      stream: addPostModel.stopWatchTimer.rawTime,
      initialData: addPostModel.stopWatchTimer.rawTime.value,
      builder: (context,snapshot) {
        final value = snapshot.data!.toInt();
        if (value >= maxPostMilliSeconds) {
          addPostModel.stopMeasure();
          addPostModel.audioRecorder.stop();
        }
        final displayTime = StopWatchTimer.getDisplayTime(
          value,
          hours: false,
          milliSecond: false,
        );
        return Column(
          children: [
            boldText(text: displayTime),
            Text('(Max 1:00)',style: TextStyle(fontSize: fontSize!/2.5,),)
          ],
        );
      }
    );
  }
}