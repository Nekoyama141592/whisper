import 'package:flutter/material.dart';

import 'package:whisper/components/notifications/components/follow_notifications/components/follow_notification_list.dart';
class FollowNotification extends StatelessWidget {

  FollowNotification(this.newFollowNotifications);
  final List<dynamic> newFollowNotifications;
  @override 
  Widget build(BuildContext context) {
    return 
    FollowNotificationList(
      newFollowNotifications
    );
  }
}