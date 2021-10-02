// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/nothing.dart';

class JudgeScreen extends StatelessWidget {
  
  const JudgeScreen({
    Key? key,
    required this.postDocs,
    required this.content
  }) : super(key: key);
  
  final List<DocumentSnapshot> postDocs;
  final Widget content;

  @override Widget build(BuildContext context) {
    return 
    postDocs.isEmpty ?
    Nothing() : content;
  }
}