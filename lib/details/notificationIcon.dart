import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/routes.dart';
import 'package:whisper/main_model.dart';

class NotificationIcon extends StatelessWidget {

  NotificationIcon(
    this.mainProvider,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final MainModel mainProvider;
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
            mainProvider, 
            preservatedPostIds, 
            likedPostIds
          );
        },
        child: mainProvider.newLikeNotifications.length > 0 || 
        mainProvider.newFollowNotifications.length > 0 ?
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