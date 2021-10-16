// material
import 'package:flutter/material.dart';
// package
import 'package:marquee/marquee.dart';

class WhisperMarquee extends StatelessWidget {

  const WhisperMarquee({
    Key? key,
    required this.text,
    required this.textStyle
  }) : super(key: key);

  final String text;
  final TextStyle textStyle;

  @override 
  Widget build(BuildContext context) {
    return Marquee(
      text: text,
      scrollAxis: Axis.horizontal,
      crossAxisAlignment: CrossAxisAlignment.start,
      blankSpace: 20.0,
      velocity: 100.0,
      pauseAfterRound: Duration(seconds: 1),
      startPadding: 10.0,
      accelerationDuration: Duration(seconds: 1),
      accelerationCurve: Curves.linear,
      decelerationDuration: Duration(milliseconds: 500),
      decelerationCurve: Curves.easeOut,
    );
  }
}