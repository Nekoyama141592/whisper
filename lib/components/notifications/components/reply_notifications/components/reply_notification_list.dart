// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/components/notifications/details/notification_card.dart';
// model
import 'package:whisper/main_model.dart';

class ReplyNotificationList extends StatelessWidget {

  const ReplyNotificationList({
    Key? key,
    required this.notifications,
    required this.mainModel
  }) : super(key: key);

  final List<dynamic> notifications;
  final MainModel mainModel;
  
  @override

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (BuildContext context, int i) {
        final notification = notifications[i];
        return NotificationCard(giveCommentId: notification[elementIdKey], firstSubTitle: notification[commentKey], secondSubTitle: notification[replyKey], notification: notification, mainModel: mainModel);
      }
    );
  }

}