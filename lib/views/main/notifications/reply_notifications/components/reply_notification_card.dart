// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/one_post/one_post_model.dart';
import 'package:whisper/models/one_comment/one_comment_model.dart';
import 'package:whisper/models/main/notifications/reply_notifications_model.dart';

class ReplyNotificationCard extends ConsumerWidget {

  const ReplyNotificationCard({
    Key? key,
    required this.mainModel,
    required this.replyNotification,
    required this.replyNotificationsModel
  }) : super(key: key);

  final MainModel mainModel;
  final ReplyNotification replyNotification;
  final ReplyNotificationsModel replyNotificationsModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final length = defaultPadding(context: context) * 4.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final userImageURL = replyNotification.userImageURL;

    return isDisplayUidFromMap(mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids,uid: replyNotification.activeUid, ) && !mainModel.mutePostCommentReplyIds.contains(replyNotification.postCommentReplyId) ?
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
              leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.userImageURL,uid: replyNotification.activeUid,mainModel: mainModel, ),
              subtitle: Text(replyNotification.comment,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) ),),
            ),
          ),
          ListTile(
            title: Text(replyNotification.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) ),),
            tileColor: replyNotificationsModel.isReadNotification(replyNotification.notificationId) ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).highlightColor.withOpacity(notificationCardOpacity),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUid: replyNotification.activeUid,mainModel: mainModel,),
            subtitle: Text(replyNotification.reply,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,fontSize: defaultHeaderTextSize(context: context) ),),
            onTap: () async => await replyNotificationsModel.onCardPressed(context: context, mainModel: mainModel, onePostModel: onePostModel, oneCommentModel: oneCommentModel, replyNotification: replyNotification),
          )
        ],
      ),
    ) : SizedBox.shrink();
  }
}