// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/notifications/components/reply_notifications/components/reply_notification_card.dart';
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
      itemBuilder: (BuildContext context, int i) => 
      ReaplyNotificationCard(notification: notifications[i],mainModel: mainModel,)
    );
  }

}