// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/user_image.dart';
import 'package:whisper/details/redirect_user_image.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
// domain
import 'package:whisper/domain/reply_notification/reply_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class ReplyNotificationCard extends ConsumerWidget {

  const ReplyNotificationCard({
    Key? key,
    required this.notification,
    required this.mainModel
  }) : super(key: key);

  final ReplyNotification notification;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final length = 60.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final userImageURL = notification.userImageURL;

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading:  UserImage(padding: padding, length: length ,userImageURL: currentWhisperUser.imageURL ),
            title: Text(currentWhisperUser.userName,style: TextStyle(fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis,),),
            subtitle: Text(notification.comment,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
          ),
          ListTile(
            tileColor: notification.isRead == true ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: notification.activeUid,mainModel: mainModel,),
            subtitle: Text(notification.reply,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            onTap: () async {
              final String givePostId = notification.postId;
              await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: notification.toJson(), oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: notification.elementId, givePostId: givePostId);
            },
          )
        ],
      ),
    );
  }
}