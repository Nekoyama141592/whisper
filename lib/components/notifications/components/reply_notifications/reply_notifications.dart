// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/strings.dart';
// component
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/details/notification_card.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/components/reply_notifications/reply_notifications_model.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.replyNotificationsModel,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;
  final ReplyNotificationsModel replyNotificationsModel;

  @override 
  Widget build(BuildContext context) {
    final notifications = replyNotificationsModel.notificationDocs;
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final ReplyNotification notification = fromMapToReplyNotification(notificationMap: notifications[i].data()!);
        return NotificationCard(giveCommentId: notification.elementId, firstSubTitle: notification.comment, secondSubTitle: notification.reply, notification: notification, mainModel: mainModel);
      }
    );
    final reload = () async {
      await replyNotificationsModel.onReload();
    };
    return replyNotificationsModel.isLoading ?
    SizedBox.shrink()
    : Container(
      child: notifications.isEmpty ?
      Nothing(reload: reload)
      : content,
    );
  }
}