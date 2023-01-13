// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// component
import 'package:whisper/details/refresh_screen.dart';
import 'package:whisper/models/main/notifications/reply_notifications_model.dart';
import 'package:whisper/views/main/notifications/reply_notifications/components/reply_notification_card.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';

class ReplyNotifications extends ConsumerWidget {

  const ReplyNotifications({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref ) {
    final ReplyNotificationsModel replyNotificationsModel = ref.watch(replyNotificationsProvider);
    final List<ReplyNotification> replyNotifications = replyNotificationsModel.docs.map((e) => ReplyNotification.fromJson(e.data()!) ).toList();
    return RefreshScreen(
      isEmpty: replyNotifications.isEmpty,
      subWidget: SizedBox.shrink(),
      controller: replyNotificationsModel.refreshController,
      onRefresh: () async => await replyNotificationsModel.onRefresh(),
      onReload: () async => await replyNotificationsModel.onReload(),
      onLoading: () async => await replyNotificationsModel.onLoading(),
      child: ListView.builder(
        itemCount: replyNotifications.length,
        itemBuilder: (BuildContext context, int i) {
          final ReplyNotification replyNotification = replyNotifications[i];
          return ReplyNotificationCard(mainModel: mainModel, replyNotification: replyNotification, replyNotificationsModel: replyNotificationsModel);
        }
      ),
    );
  }
}