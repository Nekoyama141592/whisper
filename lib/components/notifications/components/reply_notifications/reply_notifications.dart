// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';
// component
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/details/notification_card.dart';
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
        final notification = notifications[i];
        return NotificationCard(giveCommentId: notification[elementIdKey], firstSubTitle: notification[commentKey], secondSubTitle: notification[replyKey], notification: notification, mainModel: mainModel);
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