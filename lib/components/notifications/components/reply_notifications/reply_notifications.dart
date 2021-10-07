// material
import 'package:flutter/material.dart';
// component
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_list.dart';
import 'package:whisper/components/notifications/details/notification_judge_screen.dart';
class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.replyNotifications
  }) : super(key: key);

  final List<dynamic> replyNotifications;

  @override 
  Widget build(BuildContext context) {
    final list = replyNotifications;
    final content = ReplyNotificationList(notifications: replyNotifications);
    return NotificationJudgeScreen(list: list, content: content);
  }
}