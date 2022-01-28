// material
import 'package:flutter/material.dart';
// component
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_card.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.mainModel,
    required this.notificationsModel
  }) : super(key: key);

  final MainModel mainModel;
  final NotificationsModel notificationsModel;

  @override 
  Widget build(BuildContext context) {
    final notifications = notificationsModel.replyNotifications;
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final ReplyNotification notification = notifications[i];
        return ReplyNotificationCard(notification: notification, mainModel: mainModel);
      }
    );
    final reload = () {};
    return notificationsModel.isLoading ?
    SizedBox.shrink()
    : Container(
      child: notifications.isEmpty ?
      Nothing(reload: reload)
      : content,
    );
  }
}