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
import 'package:whisper/components/notifications/notifications_model.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
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
  //   return StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
  //     stream: notificationsModel.notificationStream,
  //     builder: (context, snapshot) {
  //       final List<CommentNotification> commentNotifications = snapshot.data == null ? [] :  snapshot.data!.docs.where((element) => CommentNotification.fromJson(element.data()).notificationType == commentNotificationType ).map((e) => CommentNotification.fromJson(e.data()) ).toList();
  //       final content = ListView.builder(
  //         itemCount: commentNotifications.length,
  //         itemBuilder: (BuildContext context, int i) {
  //           final CommentNotification notification = commentNotifications[i];
  //           return CommentNotificationCard(commentNotification: notification, mainModel: mainModel,notificationsModel: notificationsModel, );
  //         }
  //       );
  //       final reload = () {};
  //       return isLoading ?
  //       SizedBox.shrink()
  //       : Container(
  //         child: commentNotifications.isEmpty ?
  //         Nothing(reload: reload)
  //         : content,
  //       );
  //     }
  //   );
  // }
    final List<CommentNotification> commentNotifications = notifications.isEmpty ? [] :  notifications.where((element) => CommentNotification.fromJson(element.data()!).notificationType == commentNotificationType ).map((e) => CommentNotification.fromJson(e.data()!) ).toList();
    final content = ListView.builder(
      itemCount: commentNotifications.length,
      itemBuilder: (BuildContext context, int i) {
        final CommentNotification notification = commentNotifications[i];
        return CommentNotificationCard(commentNotification: notification, mainModel: mainModel,notificationsModel: notificationsModel, );
      }
    );
    final reload = () {
      print(notifications.isEmpty);
    };
    return notificationsModel.isLoading ?
    SizedBox.shrink()
    : Container(
      child: commentNotifications.isEmpty ?
      Nothing(reload: reload)
      : content,
    );
  }
}