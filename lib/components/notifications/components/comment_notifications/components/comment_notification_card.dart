// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/notification_model.dart';

class CommentNotificationCard extends ConsumerWidget {

  const CommentNotificationCard({
    Key? key,
    required this.notification,
    required this.currentUserDoc,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> notification;
  final DocumentSnapshot currentUserDoc;
  final MainModel mainModel;
  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final notificationModel = watch(notificationProvider);
    final readNotificationIds = notificationModel.localReadNotificationIds;
    final userImageURL = notification['userImageURL'];
    final String notificationId = notification['notificationId'];

    return InkWell(
      onTap: notificationModel.isLoading ? 
      null : 
      () async {
        if (!readNotificationIds.contains(notificationId)) {
          await notificationModel.resetReadNotificationIdsOfCurrentUser(notificationId);
        }
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor,
              leading: RedirectUserImage(userImageURL: userImageURL, length: 60.0, padding: 0.0,passiveUserDocId: notification['userDocId'],mainModel: mainModel,),
              title: Text(notification['userName']),
              subtitle: Text(notification['comment']),
            )
          ],
        ),
      ),
    );
  }
}