// material
import 'package:flutter/material.dart';
// component
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/details/notification_judge_screen.dart';
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_list.dart';
// model
import 'package:whisper/main_model.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.replyNotifications,
    required this.mainModel
  }) : super(key: key);

  final List<dynamic> replyNotifications;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    final list = replyNotifications;
    final content = ReplyNotificationList(notifications: replyNotifications,mainModel: mainModel,);
    return list.isEmpty ?
    Nothing()
    : NotificationJudgeScreen(list: list, content: content);
  }
}