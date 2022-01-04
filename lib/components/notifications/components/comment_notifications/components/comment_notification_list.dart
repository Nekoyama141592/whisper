// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/strings.dart';
// components
import 'package:whisper/components/notifications/details/notification_card.dart';
// model
import 'package:whisper/main_model.dart';

class CommentNotificationList extends StatelessWidget {

  const CommentNotificationList({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;

  @override

  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: mainModel.commentNotifications.length,
      itemBuilder: (BuildContext context, int i) {
        final notification = mainModel.commentNotifications[i];
        return NotificationCard(giveCommentId: notification[commentIdKey], firstSubTitle: notification[postTitleKey], secondSubTitle: notification[commentKey], notification: notification, mainModel: mainModel);
      }
    );
  }

}