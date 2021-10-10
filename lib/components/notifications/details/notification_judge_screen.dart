// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/nothing.dart';

class NotificationJudgeScreen extends StatelessWidget {

  const NotificationJudgeScreen({
    Key? key,
    required this.list,
    required this.content
  }) : super(key: key);
  final List<dynamic> list;
  final Widget content;

  @override 
  Widget build(BuildContext context) {
    return list.isEmpty ? Nothing() : content;
  }
}