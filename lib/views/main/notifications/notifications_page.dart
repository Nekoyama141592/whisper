// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/widgets.dart';
// constants
import '../../../constants/comment_notificationtab_bar_elements.dart';
// components
import 'package:whisper/details/whisper_drawer.dart';
// domain
import 'package:whisper/views/main/notifications/reply_notifications/reply_notifications.dart';
import 'package:whisper/views/main/notifications/comment_notifications/comment_notifications.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/themes/themes_model.dart';
import 'package:whisper/models/main/notifications_model.dart';

class NotificationsPage extends StatelessWidget {

  const NotificationsPage({
    Key? key,
    required this.mainModel,
    required this.themeModel,
    required this.notificationsModel,
  });

  final MainModel mainModel;
  final ThemeModel themeModel;
  final NotificationsModel notificationsModel;

  @override  
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarElements.length,
      child: Scaffold(
        appBar: AppBar(
          title: whiteBoldEllipsisHeaderText(context: context, text: 'Notifications'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular( defaultPadding(context: context) )
            )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              onPressed: () => Navigator.pop(context)
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
        drawer: WhisperDrawer(mainModel: mainModel, themeModel: themeModel,),
        
        body: 
        TabBarView(
          children: [
            CommentNotifications( mainModel: mainModel,notificationsModel: notificationsModel, ),
            ReplyNotifications(mainModel: mainModel, notificationsModel: notificationsModel, )
          ]
        )
      ),
    );
  }
}