// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/notifications/notification_model.dart';

class ReaplyNotificationCard extends ConsumerWidget {

  const ReaplyNotificationCard({
    Key? key,
    required this.replyNotification,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> replyNotification;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final notificationModel = watch(notificationProvider);
    final userImageURL = replyNotification['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    final notificationId = replyNotification['notificationId'];

    return InkWell(
      onTap: notificationModel.isLoading ?
      () async {
        print(notificationModel.localReadNotificationIds);
        print(notificationId);
        if (!notificationModel.localReadNotificationIds.contains(notificationId)) {
          await notificationModel.resetReadNotificationIdsOfCurrentUser(notificationId);
        }
      } : null,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: replyNotification['userDocId'],mainModel: mainModel,),
              title: Text(replyNotification['userName']),
              subtitle: Text(replyNotification['comment']),
            )
          ],
        ),
      ),
    );
  }
}