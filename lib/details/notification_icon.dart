// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart' as routes;
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/components/notifications/components/reply_notifications/reply_notifications_model.dart';
import 'package:whisper/components/notifications/components/comment_notifications/comment_notifications_model.dart';

class NotificationIcon extends ConsumerWidget {

  const NotificationIcon({
    Key? key,
    required this.mainModel,
    required this.themeModel,
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;

  @override  
  Widget build(BuildContext context, ScopedReader watch) {
  //   final replyNotificationsModel = watch(replyNotificationsProvider);
  //   final commentNotificationsModel = watch(commentNotificationsProvider);
  //   return 
  //   Padding(
  //     padding: EdgeInsets.all(20.0),
  //     child: InkWell(
  //       onTap: () {
  //         routes.toNotificationsPage(context: context, mainModel: mainModel, themeModel: themeModel, commentNotificationsModel: commentNotificationsModel, replyNotificationsModel: replyNotificationsModel);
  //       },
  //       child: newNotificationExists(mainModel: mainModel,replyNotifications: replyNotificationsModel.notificationDocs, commentNotifications: commentNotificationsModel.notificationDocs ) ?
  //       Stack(
  //         children: [
  //           Icon(Icons.notifications),
  //           Positioned(
  //             right: 0,
  //             top: 0,
  //             child: Container(
  //               height: 12,
  //               width: 12,
  //               decoration: BoxDecoration(
  //                 color: kErrorColor,
  //                 shape: BoxShape.circle
  //               ),
  //             )
  //           )
  //         ],
  //       )
  //       : Icon(Icons.notifications),
  //     ),
  //   );
  // }
  return SizedBox();
  }
}