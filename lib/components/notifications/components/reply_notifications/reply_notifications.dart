// material
import 'package:flutter/material.dart';
// component
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_list.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.notifications
  }) : super(key: key);

  final List<dynamic> notifications;

  @override 
  Widget build(BuildContext context) {
    return ReplyNotificationList(notifications: notifications);
  }
}