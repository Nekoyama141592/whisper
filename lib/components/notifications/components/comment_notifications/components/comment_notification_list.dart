// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_card.dart';
// model
import 'package:whisper/main_model.dart';

class CommentNotificationList extends StatelessWidget {

  const CommentNotificationList({
    Key? key,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);

  final DocumentSnapshot currentUserDoc;
  final MainModel mainModel;

  @override

  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: mainModel.commentNotifications.length,
      itemBuilder: (BuildContext context, int i) => 
      CommentNotificationCard(notification: mainModel.commentNotifications[i],currentUserDoc: currentUserDoc,mainModel: mainModel,)
    );
  }

}