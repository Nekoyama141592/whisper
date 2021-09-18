import 'package:flutter/material.dart';

import 'package:whisper/parts/notifications/components/user_notification/user_notification_card.dart';
class UserNotificationList extends StatelessWidget {

  UserNotificationList(this.notification);

  final Map<String,dynamic> notification;
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int i) =>
        UserNotificationCard(
          notification
        )
      )
    );
  }
}