import 'package:flutter/material.dart';

import 'package:whisper/parts/notifications/components/post_notification/components/post_notification_card.dart';
class PostNotificationList extends StatelessWidget {

  PostNotificationList(this.notification);

  final Map<String,dynamic> notification;
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int i) =>
        PostNotificationCard(
          notification
        )
      )
    );
  }
}