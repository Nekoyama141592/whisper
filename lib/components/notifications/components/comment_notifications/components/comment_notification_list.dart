// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_card.dart';

class CommentNotificationList extends StatelessWidget {

  const CommentNotificationList({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final List<dynamic> notifications;
  
  @override

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) => 
      ReaplyNotificationCard(notification: notifications[i] )
    );
  }

}