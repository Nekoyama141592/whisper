// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class ReaplyNotificationCard extends ConsumerWidget {

  const ReaplyNotificationCard({
    Key? key,
    required this.notification,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> notification;
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final userImageURL = notification[userImageURLKey];
    final length = 60.0;
    final padding = 0.0;
    final notificationId = notification[notificationIdKey];
    final OnePostModel onePostModel = watch(onePostProvider);
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           ListTile(
            leading:  UserImage(padding: 0.0, length: 60.0, userImageURL: mainModel.currentUserDoc[imageURLKey]),
            title: Text(mainModel.currentUserDoc[userNameKey],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
            subtitle: Text(notification[commentKey],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
          ),
          ListTile(
            tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: notification[uidKey],mainModel: mainModel,),
            title: Text(notification[userNameKey],overflow: TextOverflow.ellipsis,),
            subtitle: Text(notification[replyKey],style: TextStyle(color: Theme.of(context).focusColor),overflow: TextOverflow.ellipsis,),
            onTap: () async {
              // Please don`t use notification['commentId']. The commentNotification is different from replyNotification.
              final String giveCommentId = notification[elementIdKey];
              final String givePostId = notification[postIdKey];
              await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification, oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
            },
          ),
          
        ],
      ),
    );
  }
}