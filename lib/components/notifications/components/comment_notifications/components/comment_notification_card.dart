// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/doubles.dart';
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

    final length = defaultPadding(context: context) * 4.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final userImageURL = commentNotification.userImageURL;
    
    return Padding(
      padding: EdgeInsets.all(defaultPadding(context: context)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(defaultPadding(context: context)),
          color: Theme.of(context).focusColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              tileColor: Theme.of(context).scaffoldBackgroundColor,
              leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.imageURL ),
              title: Text(currentWhisperUser.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context), ),),
              subtitle: Text(commentNotification.postTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context), ),),
            ),
            ListTile(
              tileColor: commentNotification.isRead == true ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).highlightColor.withOpacity(notificationCardOpacity),
              leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: commentNotification.activeUid,mainModel: mainModel,),
              subtitle: Text(commentNotification.comment,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context), ),),
              onTap: () async {
                await notificationsModel.onCommentNotificationPressed(context: context, mainModel: mainModel, onePostModel: onePostModel, oneCommentModel: oneCommentModel, commentNotification: commentNotification);
              },
            )
          ],
        ),
      ),
    );
  }
}