// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
// model
import 'package:whisper/components/notifications/notification_model.dart';

class CommentNotificationCard extends ConsumerWidget {

  const CommentNotificationCard({
    Key? key,
    required this.notification,
    required this.currentUserDoc,
    required this.readNotificationIds
  }) : super(key: key);
  
  final Map<String,dynamic> notification;
  final DocumentSnapshot currentUserDoc;
  final List<dynamic> readNotificationIds;
  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final notificationModel = watch(notificationProvider);
    final userImageURL = notification['userImageURL'];
    final String notificationId = notification['notificationId'];
    return InkWell(
      onTap: () async {
        await notificationModel.updateReadNotificationIdsOfCurrentUser(currentUserDoc, notificationId, readNotificationIds);
      },
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor,
              leading: UserImage(userImageURL: userImageURL, length: 60.0, padding: 0.0),
              title: Text(notification['userName']),
              subtitle: Text(notification['comment']),
            )
          ],
        ),
      ),
    );
  }
}