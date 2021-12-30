// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_card.dart';
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
      itemBuilder: (BuildContext context, int i) => 
      CommentNotificationCard(notification: mainModel.commentNotifications[i],currentUserDoc: mainModel.currentUserDoc,mainModel: mainModel,)
    );
  }

}