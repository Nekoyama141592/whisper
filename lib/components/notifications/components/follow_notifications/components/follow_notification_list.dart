import 'package:flutter/material.dart';

import 'package:whisper/components/notifications/components/follow_notifications/components/follow_notification_card.dart';
class FollowNotificationList extends StatelessWidget {

  FollowNotificationList(this.notifications);

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