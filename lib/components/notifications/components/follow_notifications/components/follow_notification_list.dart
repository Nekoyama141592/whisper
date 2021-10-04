// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/notifications/components/follow_notifications/components/follow_notification_card.dart';

class FollowNotificationList extends StatelessWidget {

  const FollowNotificationList({
    Key? key,
    required this.notifications
  }) : super(key: key);

  final List<dynamic> notifications;
  
  @override 
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) =>
      FollowNotificationCard(
        notifications[i]
      )
    );
  }
}