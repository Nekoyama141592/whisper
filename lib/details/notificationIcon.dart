// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class NotificationIcon extends StatelessWidget {

  const NotificationIcon({
    Key? key,
    required this.mainModel,
    required this.themeModel,
    required this.bookmarkedPostIds,
    required this.likedPostIds
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;
  final List bookmarkedPostIds;
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
            bookmarkedPostIds, 
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