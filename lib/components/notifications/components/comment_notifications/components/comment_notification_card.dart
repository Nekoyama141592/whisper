// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
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
             leading:  UserImage(padding: 0.0, length: 60.0, userImageURL: currentUserDoc['imageURL']),
             title: Text(currentUserDoc['userName'],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
             subtitle: Text(notification['postTitle'],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
           ),
            ListTile(
              tileColor: readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
              leading: RedirectUserImage(userImageURL: userImageURL, length: 60.0, padding: 0.0,passiveUserDocId: notification['userDocId'],mainModel: mainModel,),
              title: Text(notification['userName'],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
              subtitle: Text(notification['comment'],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            )
          ],
        ),
      ),
    );
  }
}