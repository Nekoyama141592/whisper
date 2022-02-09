// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/strings.dart';
// component
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_card.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.mainModel,
    required this.notificationsModel,
    required this.notifications
  }) : super(key: key);

  final MainModel mainModel;
  final NotificationsModel notificationsModel;
  final List<DocumentSnapshot<Map<String,dynamic>>> notifications;

  @override 
  Widget build(BuildContext context) {
    // return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
    //   stream: notificationsModel.notificationStream,
    //   builder: (context, snapshot) {
       
    //   }
    // );
    final List<ReplyNotification> replyNotifications = notifications.isEmpty ? [] : notifications.where((element) => ReplyNotification.fromJson(element.data()!).notificationType == replyNotificationType ).map((e) => ReplyNotification.fromJson(e.data()!) ).toList();
        final content = ListView.builder(
          itemCount: replyNotifications.length,
          itemBuilder: (BuildContext context, int i) {
            final ReplyNotification notification = replyNotifications[i];
            return ReplyNotificationCard(replyNotification: notification, mainModel: mainModel,notificationsModel: notificationsModel,  );
          }
        );
        final reload = () {
        };
        return notificationsModel.isLoading ?
        SizedBox.shrink()
        : Container(
          child: replyNotifications.isEmpty ?
          Nothing(reload: reload)
          : content,
        );
  }
}