// material
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/routes.dart' as routes;
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class NotificationIcon extends ConsumerWidget {

  const NotificationIcon({
    Key? key,
    required this.mainModel,
    required this.themeModel,
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;

  @override  
  Widget build(BuildContext context, WidgetRef ref) {
  final NotificationsModel notificationsModel = ref.watch(notificationsProvider);
  
  return Padding(
    padding: EdgeInsets.all(defaultPadding(context: context)),
    child: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
      stream: notificationsModel.notificationStream,
      builder: ( context,snapshot ) {
        bool isNotificationExists = (snapshot.data == null) ? false : snapshot.data!.docs.isNotEmpty;
        return InkWell(
          onTap: () {
            routes.toNotificationsPage(context: context, mainModel: mainModel, themeModel: themeModel, notificationsModel: notificationsModel,);
          },
          child: 
          
          Stack(
            children: [
              Icon(Icons.notifications),
              isNotificationExists ?
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  height: defaultPadding(context: context)/notificationDiv,
                  width: defaultPadding(context: context)/notificationDiv,
                  decoration: BoxDecoration(
                    color: kErrorColor,
                    shape: BoxShape.circle
                  ),
                )
              ) : SizedBox.shrink()
            ]
          ),
        );
      }
    ),
  );
  }
}