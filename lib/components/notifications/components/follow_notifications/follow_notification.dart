// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/notifications/components/follow_notifications/components/follow_notification_list.dart';

class FollowNotification extends StatelessWidget {

  const FollowNotification({
    Key? key,
    required this.newFollowNotifications
  }) : super(key: key);

  final List<dynamic> newFollowNotifications;

  @override 
  Widget build(BuildContext context) {
    final notifications = newFollowNotifications;
    return FollowNotificationList(notifications: notifications);
  }
  
}