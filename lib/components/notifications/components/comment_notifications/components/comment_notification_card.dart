// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
// constants
import 'package:whisper/constants/bools.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// domain
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class CommentNotificationCard extends ConsumerWidget {

  const CommentNotificationCard({
    Key? key,
    required this.mainModel,
    required this.commentNotification,
    required this.notificationsModel,
  }) : super(key: key);

  final MainModel mainModel;
  final CommentNotification commentNotification;
  final NotificationsModel notificationsModel;


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final length = defaultPadding(context: context) * 3.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final userImageURL = commentNotification.userImageURL;
    
    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: commentNotification.activeUid, ) && !mainModel.mutePostCommentIds.contains(commentNotification.postCommentId) ?
    Padding(
      padding: EdgeInsets.all(defaultPadding(context: context)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(defaultPadding(context: context))
              ),
            ),
            child: ListTile(
              tileColor: Theme.of(context).scaffoldBackgroundColor,
              leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.userImageURL,uid: commentNotification.activeUid,mainModel: mainModel, ),
              subtitle: Text(commentNotification.postTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context), ),),
            ),
          ),
          ListTile(
            title: Text(commentNotification.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) ),),
            tileColor: notificationsModel.readPostCommentNotificationIds.contains(commentNotification.notificationId) ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).highlightColor.withOpacity(notificationCardOpacity),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUid: commentNotification.activeUid,mainModel: mainModel,),
            subtitle: Text(commentNotification.comment,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context), ),),
            onTap: () async {
              await notificationsModel.onCommentNotificationPressed(context: context, mainModel: mainModel, onePostModel: onePostModel, oneCommentModel: oneCommentModel, commentNotification: commentNotification);
            },
          )
        ],
      ),
    ) : SizedBox.shrink();
  }
}