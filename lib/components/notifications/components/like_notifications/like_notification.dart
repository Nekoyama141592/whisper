import 'package:flutter/material.dart';

import 'package:whisper/components/notifications/components/like_notifications/components/like_notification_list.dart';

class LikeNotification extends StatelessWidget {

  LikeNotification(this.newLikeNotifications);
  final List<dynamic> newLikeNotifications;
  @override 
  Widget build(BuildContext context) {
    return 
    LikeNotificationList(
      newLikeNotifications
    );
    
  }
}