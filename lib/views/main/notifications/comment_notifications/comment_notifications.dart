// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/views/main/notifications/comment_notifications/components/comment_notification_card.dart';
// domain
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/notifications/comment_notifications_model.dart';

class CommentNotifications extends ConsumerWidget {

  const CommentNotifications({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final CommentNotificationsModel commentNotificationsModel = ref.watch(commentNotificationsProvider);
    final List<CommentNotification> commentNotifications = commentNotificationsModel.docs.map((e) => CommentNotification.fromJson(e.data()!) ).toList();
    return RefreshScreen(
      isEmpty: commentNotifications.isEmpty,
      subWidget: SizedBox.shrink(),
      controller: commentNotificationsModel.refreshController,
      onRefresh: () async => await commentNotificationsModel.onRefresh(),
      onReload: () async => await commentNotificationsModel.onReload(),
      onLoading: () async => await commentNotificationsModel.onLoading(),
      child: ListView.builder(
        itemCount: commentNotifications.length,
        itemBuilder: (BuildContext context, int i) {
          final CommentNotification notification = commentNotifications[i];
          return CommentNotificationCard(commentNotification: notification, mainModel: mainModel,commentNotificationsModel: commentNotificationsModel, );
        }
      ),
    );
  }
}