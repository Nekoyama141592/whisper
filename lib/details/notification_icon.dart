// material
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.likedPostIds,
    required this.replyNotifications,
    required this.currentUserDoc,
    required this.readNotificationIds
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;
  final List bookmarkedPostIds;
  final List likedPostIds;
  final List replyNotifications;
  final DocumentSnapshot currentUserDoc;
  final List<String> readNotificationIds;
  @override  
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          toNotificationsPage(
            context, 
            mainModel,
            themeModel,
            bookmarkedPostIds, 
            likedPostIds,
            replyNotifications,
            currentUserDoc,
          );
        },
        child: mainModel.newNotificationExists ?
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