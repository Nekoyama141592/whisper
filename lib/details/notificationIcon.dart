// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class NotificationIcon extends StatelessWidget {

  NotificationIcon(
    this.mainModel,
    this.themeModel,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final MainModel mainModel;
  final ThemeModel themeModel;
  final List preservatedPostIds;
  final List likedPostIds;
  @override  
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: EdgeInsets.all(20),
      child: InkWell(
        onTap: () {
          toNotificationsPage(
            context, 
            mainModel,
            themeModel,
            preservatedPostIds, 
            likedPostIds
          );
        },
        child: mainModel.newLikeNotifications.length > 0 || 
        mainModel.newFollowNotifications.length > 0 ?
        Stack(
          children: [
            Icon(Icons.notifications),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: kErrorColor,
                  shape: BoxShape.circle
                ),
              )
            )
          ],
        )
        : Icon(Icons.notifications),
      ),
    );
  }
}