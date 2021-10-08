// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_card.dart';

class CommentNotificationList extends StatelessWidget {

  const CommentNotificationList({
    Key? key,
    required this.currentUserDoc,
    required this.readNotificationIds
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final List<dynamic> readNotificationIds;

  @override

  Widget build(BuildContext context) {
    final commentNotifications = currentUserDoc['commentNotifications'];
    return ListView.builder(
      itemCount: commentNotifications.length,
      itemBuilder: (BuildContext context, int i) => 
      CommentNotificationCard(notification: commentNotifications[i],currentUserDoc: currentUserDoc,readNotificationIds: readNotificationIds,)
    );
  }

}