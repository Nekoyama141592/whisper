import 'package:flutter/material.dart';

import 'package:whisper/parts/notifications/components/follow_notification/components/follow_notification_list.dart';
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