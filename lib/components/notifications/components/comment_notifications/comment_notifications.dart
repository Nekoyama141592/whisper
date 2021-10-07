// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_list.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
    Key? key,
    required this.currentUserDoc
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  @override 
  Widget build(BuildContext context) {
    return CommentNotificationList(currentUserDoc: currentUserDoc);
  }
}