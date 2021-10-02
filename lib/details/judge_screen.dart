// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/details/loading.dart';

class JudgeScreen extends StatelessWidget {
  
  const JudgeScreen({
    Key? key,
    required this.isLoading,
    required this.postDocs,
    required this.content
  }) : super(key: key);
  
  final bool isLoading;
  final List<DocumentSnapshot> postDocs;
  final Widget content;

  @override Widget build(BuildContext context) {
    return isLoading ?
    Loading()
    : postDocs.isEmpty ?
    Nothing() : content;
  }
}