// material
import 'package:flutter/material.dart';
import 'package:whisper/components/notifications/components/comment_notifications/comment_notifications.dart';
// constants
import 'constants/tab_bar_elements.dart';
// components
import 'package:whisper/details/whisper_drawer.dart';
import 'package:whisper/components/notifications/components/reply_notifications/reply_notifications.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/links/links_model.dart';
import 'package:whisper/themes/themes_model.dart';
import 'package:whisper/components/notifications/notifications_model.dart';

class NotificationsPage extends StatelessWidget {

  const NotificationsPage({
    Key? key,
    required this.mainModel,
    required this.linksModel,
    required this.themeModel,
    required this.notificationsModel
  });

  final MainModel mainModel;
  final LinksModel linksModel;
  final ThemeModel themeModel;
  final NotificationsModel notificationsModel;

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
        drawer: WhisperDrawer(mainModel: mainModel, themeModel: themeModel, linksModel: linksModel),
        body: TabBarView(
          children: [
            CommentNotifications(mainModel: mainModel, notificationsModel: notificationsModel),
            ReplyNotifications(mainModel: mainModel, notificationsModel: notificationsModel),
          ]
        ),
      ),
    );
  }
}