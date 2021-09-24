import 'package:flutter/material.dart';

import 'constants/tab_bar_elements.dart';

import 'package:whisper/main_model.dart';
import 'package:whisper/details/whisper_drawer.dart';
import 'package:whisper/components/notifications/components/like_notifications/like_notification.dart';
import 'package:whisper/components/notifications/components/follow_notifications/follow_notification.dart';

class NotificationsPage extends StatelessWidget {

  NotificationsPage(
    this.mainProvider,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final MainModel mainProvider;
  final List preservatedPostIds;
  final List likedPostIds;

  @override  
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarElements.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Whisper'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30)
            )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: (){
                Navigator.pop(context);
              }, 
            )
          ],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabBarElements.map((tabBarElement) {
              return Tab(
                text: tabBarElement.title
              );
            }).toList()
          ),
          
        ),
        drawer: mainProvider.isLoading ?
        Drawer()
        : WhisperDrawer(
          mainProvider,
        ),
        body: TabBarView(
          children: [
            LikeNotification(
              mainProvider.newLikeNotifications
            ),
            FollowNotification(
              mainProvider.newFollowNotifications
            )
          ]
        ),
      ),
    );
  }
}