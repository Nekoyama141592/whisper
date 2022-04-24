// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/post/post.dart';
// l10n
import 'package:whisper/l10n/l10n.dart';

class TimestampDisplay extends StatelessWidget {

  const TimestampDisplay({
    Key? key,
    required this.whisperPost
  }) : super(key: key);

  final Post whisperPost;

  @override
  Widget build(BuildContext context) {
    final Timestamp createdAt = whisperPost.createdAt as Timestamp;
    final DateTime dateTime = createdAt.toDate();
    final L10n l10n = returnL10n(context: context)!;
    return Text(l10n.createdAt(dateTime));
  }
}