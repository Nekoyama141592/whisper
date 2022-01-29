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

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.isLoading,
    required this.mainModel,
    required this.snapshot
  }) : super(key: key);

  final bool isLoading;
  final MainModel mainModel;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override 
  Widget build(BuildContext context) {
    final List<ReplyNotification> notifications = snapshot.data!.docs.where((element) => ReplyNotification.fromJson(element.data()).notificationType == replyNotificationType ).map((e) => ReplyNotification.fromJson(e.data()) ).toList();
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final ReplyNotification notification = notifications[i];
        return ReplyNotificationCard(notification: notification, mainModel: mainModel);
      }
    );
    final reload = () {};
    return isLoading ?
    SizedBox.shrink()
    : Container(
      child: notifications.isEmpty ?
      Nothing(reload: reload)
      : content,
    );
  }
}