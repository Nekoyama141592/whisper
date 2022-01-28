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
import 'package:whisper/domain/comment_notification/comment_notification.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/one_post/one_post_model.dart';
import 'package:whisper/one_post/one_comment/one_comment_model.dart';

class CommentNotificationCard extends ConsumerWidget {

  const CommentNotificationCard({
    Key? key,
    required this.giveCommentId,
    required this.firstSubTitle,
    required this.secondSubTitle,
    required this.commentNotification,
    required this.mainModel
  }) : super(key: key);

  final String giveCommentId;
  final String firstSubTitle;
  final String secondSubTitle;
  final CommentNotification commentNotification;
  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final length = 60.0;
    final padding = 0.0;
    final currentWhisperUser = mainModel.currentWhisperUser;
    final OnePostModel onePostModel = ref.watch(onePostProvider);
    final OneCommentModel oneCommentModel = ref.watch(oneCommentProvider);
    final userImageURL = commentNotification.userImageURL;
    
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
            tileColor: commentNotification.isRead == true ? Theme.of(context).backgroundColor : Theme.of(context).highlightColor.withOpacity(0.85),
            leading: RedirectUserImage(userImageURL: userImageURL, length: length, padding: padding,passiveUserDocId: commentNotification.activeUid,mainModel: mainModel,),
            subtitle: Text(secondSubTitle,style: TextStyle(color: Theme.of(context).focusColor,overflow: TextOverflow.ellipsis,),),
            onTap: () async {
              final String givePostId = commentNotification.postId;
              await voids.onNotificationPressed(context: context, mainModel: mainModel, notification: commentNotification.toJson(), oneCommentModel: oneCommentModel, onePostModel: onePostModel, giveCommentId: giveCommentId, givePostId: givePostId);
            },
          )
        ],
      ),
    );
  }
}