// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/tab_bar_elements.dart';
// components
import 'package:whisper/details/notificationIcon.dart';
import 'package:whisper/details/whisper_drawer.dart';
// pages
import 'package:whisper/components/home/feeds/feeds_page.dart';
import 'package:whisper/components/home/recommenders/recommenders_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';


class Home extends StatelessWidget {

  const Home({
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
            NotificationIcon(
              mainModel,
              themeModel,
              bookmarkedPostIds,
              likedPostIds
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
        
        drawer: WhisperDrawer(
          mainModel: mainModel,
          themeModel: themeModel,
        ),
        body: TabBarView(
          children: [
            FeedsPage(preservatedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds),
            RecommendersPage(currentUserDoc: mainModel.currentUserDoc, preservatedPostIds: bookmarkedPostIds, likedPostIds: likedPostIds)
          ],
        ),
        
      )
    );
  }
}