// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/notifications/components/comment_notifications/components/comment_notification_list.dart';
// mainModel
import 'package:whisper/main_model.dart';

class CommentNotifications extends StatelessWidget {

  const CommentNotifications({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override 
  Widget build(BuildContext context) {
    final List<dynamic> list = mainModel.commentNotifications;
    final content = CommentNotificationList(mainModel: mainModel);
    final reload = () async {
      // await mainModel.regetNotifications();
    };
    return list.isEmpty ?
    Nothing(reload: reload)
    : content;
  }
}