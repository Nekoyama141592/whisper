// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/nothing.dart';

class JudgeScreen extends StatelessWidget {
  
  const JudgeScreen({
    Key? key,
    required this.list,
    required this.content,
    required this.reload,
  }) : super(key: key);
  
  final List<DocumentSnapshot> list;
  final Widget content;
  final void Function()? reload;

  @override Widget build(BuildContext context) {
    return 
    list.isEmpty ?
    Nothing(reload: reload) : content;
  }
}