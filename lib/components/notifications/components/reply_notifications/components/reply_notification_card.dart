// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// model
import 'package:whisper/main_model.dart';

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

    final userImageURL = replyNotification['userImageURL'];
    final length = 60.0;
    final padding = 0.0;
    final notificationId = replyNotification['notificationId'];

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           ListTile(
            leading:  UserImage(padding: 0.0, length: 60.0, userImageURL: mainModel.currentUserDoc['imageURL']),
            title: Text(mainModel.currentUserDoc['userName'],style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
            subtitle: Text(replyNotification['comment'],style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
          ),
          ListTile(
            tileColor: mainModel.readNotificationIds.contains(notificationId) ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: replyNotification['userDocId'],mainModel: mainModel,),
            title: Text(replyNotification['userName'],overflow: TextOverflow.ellipsis,),
            subtitle: Text(replyNotification['reply'],style: TextStyle(color: Theme.of(context).focusColor),overflow: TextOverflow.ellipsis,),
            onTap: () async {
              await mainModel.addNotificationIdToReadNotificationIds(notification: replyNotification);
            },
          ),
          
        ],
      ),
    );
  }
}