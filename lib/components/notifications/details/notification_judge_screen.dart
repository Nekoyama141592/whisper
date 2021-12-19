// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/nothing.dart';

class NotificationJudgeScreen extends StatelessWidget {

  const NotificationJudgeScreen({
    Key? key,
    required this.list,
    required this.content,
    required this.reload
  }) : super(key: key);

  final List<dynamic> list;
  final Widget content;
  final void Function()? reload;

  @override 
  Widget build(BuildContext context) {
    return list.isEmpty ? Nothing(reload: reload) : content;
  }
}