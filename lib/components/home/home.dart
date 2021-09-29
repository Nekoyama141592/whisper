import 'package:flutter/material.dart';
import 'package:whisper/main_model.dart';

import 'package:whisper/components/home/feeds/feeds_page.dart';
import 'package:whisper/components/home/recommenders/recommenders_page.dart';

import 'package:whisper/details/notificationIcon.dart';
import 'package:whisper/constants/tab_bar_elements.dart';

import 'package:whisper/details/whisper_drawer.dart';

class Home extends StatelessWidget {

  Home(this.mainProvider, this.preservatedPostIds,this.likedPostIds);
  
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
            NotificationIcon(
              mainProvider,
              preservatedPostIds,
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
          mainProvider,
          
        ),
        body: TabBarView(
          children: [
            FeedsPage(preservatedPostIds,likedPostIds),
            RecommendersPage(mainProvider.currentUserDoc,preservatedPostIds,likedPostIds),
          ],
        ),
        
      )
    );
  }
}