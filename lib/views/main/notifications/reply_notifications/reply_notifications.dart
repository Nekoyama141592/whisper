// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/strings.dart';
// component
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/views/main/notifications/reply_notifications/components/reply_notification_card.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/notifications_model.dart';

class ReplyNotifications extends StatelessWidget {

  const ReplyNotifications({
    Key? key,
    required this.mainModel,
    required this.notificationsModel,
  }) : super(key: key);

  final MainModel mainModel;
  final NotificationsModel notificationsModel;

  @override 
  Widget build(BuildContext context) {
    
    final List<ReplyNotification> replyNotifications = notificationsModel.notifications.where((element) => ReplyNotification.fromJson(element.data()!).notificationType == replyNotificationType ).map((e) => ReplyNotification.fromJson(e.data()!) ).toList();
    return RefreshScreen(
      isEmpty: replyNotifications.isEmpty,
      subWidget: SizedBox.shrink(),
      controller: notificationsModel.replyRefreshController,
      onRefresh: () async => await notificationsModel.onRefresh(),
      onReload: () async => await notificationsModel.onReload(),
      onLoading: () async => await notificationsModel.onLoading(),
      child: ListView.builder(
        itemCount: replyNotifications.length,
        itemBuilder: (BuildContext context, int i) {
          final ReplyNotification replyNotification = replyNotifications[i];
          return ReplyNotificationCard(mainModel: mainModel, replyNotification: replyNotification, notificationsModel: notificationsModel);
        }
      ),
    );
  }
}