// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/voids.dart' as voids;
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class CommentNotificationCard extends ConsumerWidget {

  const CommentNotificationCard({
    Key? key,
    required this.notification,
    required this.mainModel
  }) : super(key: key);
  
  final Map<String,dynamic> notification;
  final MainModel mainModel;
  @override 
  Widget build(BuildContext context,ScopedReader watch) {

    final userImageURL = notification[userImageURLKey];
    final String notificationId = notification[notificationIdKey];
    final OnePostModel onePostModel = watch(onePostProvider);
    final OneCommentModel oneCommentModel = watch(oneCommentProvider);
    final currentUserDoc = mainModel.currentUserDoc;
    
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         ListTile(
           leading:  UserImage(padding: 0.0, length: 60.0, userImageURL: currentUserDoc[imageURLKey]),
           title: Text(currentUserDoc[userNameKey],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
           subtitle: Text(notification[postTitleKey],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
         ),
          ListTile(
            tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: 60.0, padding: 0.0,passiveUserDocId: notification[uidKey],mainModel: mainModel,),
            title: Text(notification[userNameKey],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
            subtitle: Text(notification[commentKey],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            onTap: () async {
              final String giveCommentId = notification[commentIdKey];
              final String givePostId = notification[postIdKey];
              await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification, oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
            },
          )
        ],
      ),
    );
  }
}