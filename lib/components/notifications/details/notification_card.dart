// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class NotificationCard extends ConsumerWidget {

  const NotificationCard({
    Key? key,
    required this.giveCommentId,
    required this.firstSubTitle,
    required this.secondSubTitle,
    required this.notification,
    required this.mainModel
  }) : super(key: key);

  final String giveCommentId;
  final String firstSubTitle;
  final String secondSubTitle;
  final dynamic notification;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    final length = 60.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = watch(onePostProvider);
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);

    if (notification is ReplyNotification) {
      final ReplyNotification replyNotification = fromMapToReplyNotification(notificationMap: notification);
      final userImageURL = replyNotification.userImageURL;
      final String notificationId = replyNotification.notificationId;
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.imageURL ),
              title: Text(currentWhisperUser.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
              subtitle: Text(firstSubTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            ),
            ListTile(
              tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
              leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: replyNotification.uid,mainModel: mainModel,),
              subtitle: Text(secondSubTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
              onTap: () async {
                final String givePostId = replyNotification.postId;
                await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification.toJson(), oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
              },
            )
          ],
        ),
      );
    } else {
      final CommentNotification commentNotification = fromMapToCommentNotification(notificationmap: notification);
      final userImageURL = commentNotification.userImageURL;
      final String notificationId = commentNotification.notificationId;
      return Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.imageURL ),
              title: Text(currentWhisperUser.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
              subtitle: Text(firstSubTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            ),
            ListTile(
              tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
              leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: commentNotification.uid,mainModel: mainModel,),
              subtitle: Text(secondSubTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
              onTap: () async {
                final String givePostId = commentNotification.postId;
                await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification.data()!, oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
              },
            )
          ],
        ),
      );
    }
  }

}