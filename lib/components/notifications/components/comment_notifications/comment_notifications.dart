// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_card.dart';
// domain
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
    Key? key,
    required this.mainModel,
    required this.notificationsModel
  }) : super(key: key);

  final MainModel mainModel;
  final NotificationsModel notificationsModel;

  @override 
  Widget build(BuildContext context) {
    final notifications = notificationsModel.commentNotifications;
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final CommentNotification notification = notifications[i];
        return CommentNotificationCard(notification: notification, mainModel: mainModel);
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