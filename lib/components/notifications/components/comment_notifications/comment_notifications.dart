// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/strings.dart';
// packages
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
    required this.notificationsModel,
  }) : super(key: key);

  final MainModel mainModel;
  final NotificationsModel notificationsModel;

  @override
  Widget build(BuildContext context) {
    final List<CommentNotification> commentNotifications = notificationsModel.notifications.where((element) => CommentNotification.fromJson(element.data()!).notificationType == commentNotificationType ).map((e) => CommentNotification.fromJson(e.data()!) ).toList();
    final reload = () async => await notificationsModel.onReload();
    return notificationsModel.isLoading ?
    SizedBox.shrink()
    : Container(
      child: commentNotifications.isEmpty ?
      Nothing(reload: reload)
      : SmartRefresher(
        controller: notificationsModel.commentRefreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(),
        onRefresh: () async => await notificationsModel.onRefresh(),
        onLoading: () async => await notificationsModel.onLoading(),
        child: ListView.builder(
          itemCount: commentNotifications.length,
          itemBuilder: (BuildContext context, int i) {
            final CommentNotification notification = commentNotifications[i];
            return CommentNotificationCard(commentNotification: notification, mainModel: mainModel,notificationsModel: notificationsModel, );
          }
        ),
      ),
    );
  }
}