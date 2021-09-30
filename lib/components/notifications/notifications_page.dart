// material
import 'package:flutter/material.dart';
// constants
import 'constants/tab_bar_elements.dart';
// components
import 'package:whisper/details/whisper_drawer.dart';
import 'package:whisper/components/notifications/components/like_notifications/like_notification.dart';
import 'package:whisper/components/notifications/components/follow_notifications/follow_notification.dart';
// model
import 'package:whisper/main_model.dart';

class NotificationsPage extends StatelessWidget {

  NotificationsPage(
    this.mainModel,
    this.preservatedPostIds,
    this.likedPostIds
  );

  final MainModel mainModel;
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
        drawer: WhisperDrawer(mainModel: mainModel),
        body: TabBarView(
          children: [
            LikeNotification(
              mainModel.newLikeNotifications
            ),
            FollowNotification(
              mainModel.newFollowNotifications
            )
          ]
        ),
      ),
    );
  }
}