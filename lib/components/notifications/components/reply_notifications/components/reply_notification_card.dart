// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
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

    final userImageURL = notification['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    final notificationId = notification['notificationId'];
    final OnePostModel onePostModel = watch(onePostProvider);
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           ListTile(
            leading:  UserImage(padding: 0.0, length: 60.0, userImageURL: mainModel.currentUserDoc['imageURL']),
            title: Text(mainModel.currentUserDoc['userName'],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
            subtitle: Text(notification['comment'],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
          ),
          ListTile(
            tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: notification['uid'],mainModel: mainModel,),
            title: Text(notification['userName'],overflow: TextOverflow.ellipsis,),
            subtitle: Text(notification['reply'],style: TextStyle(color: Theme.of(context).focusColor),overflow: TextOverflow.ellipsis,),
            onTap: () async {
              // Please don`t use notification['commentId']. The commentNotification is different from replyNotification.
              final String giveCommentId = notification['elementId'];
              final String givePostId = notification['postId'];
              await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification, oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
            },
          ),
          
        ],
      ),
    );
  }
}