// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_card.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
// domain
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
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
    final List<CommentNotification> notifications = snapshot.data!.docs.where((element) => CommentNotification.fromJson(element.data()).notificationType == commentNotificationType ).map((e) => CommentNotification.fromJson(e.data()) ).toList();
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final CommentNotification notification = notifications[i];
        return CommentNotificationCard(notification: notification, mainModel: mainModel);
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