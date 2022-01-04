// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/details/notification_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/components/comment_notifications/comment_notifications_model.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
    Key? key,
    required this.mainModel,
    required this.commentNotificationsModel
  }) : super(key: key);

  final MainModel mainModel;
  final CommentNotificationsModel commentNotificationsModel;

  @override 
  Widget build(BuildContext context) {
    final List<DocumentSnapshot<Map<String,dynamic>>> notifications = commentNotificationsModel.notificationDocs;
    final content = ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final notification = notifications[i];
        return NotificationCard(giveCommentId: notification[commentIdKey], firstSubTitle: notification[postTitleKey], secondSubTitle: notification[commentKey], notification: notification, mainModel: mainModel);
      }
    );
    final void Function()? reload = () async {
      await commentNotificationsModel.onReload();
    };
    return commentNotificationsModel.isLoading ?
    SizedBox.shrink()
    : Container(
      child: notifications.isEmpty ?
      Nothing(reload: reload)
      : content,
    );
  }
}