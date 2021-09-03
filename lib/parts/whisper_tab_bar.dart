import 'package:flutter/material.dart';

import 'package:whisper/parts/posts/feeds/feeds_page.dart';
import 'package:whisper/parts/posts/recommenders/recommenders_page.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/constants/tab_bar_elements.dart';

class WhisperTabBar extends StatelessWidget {

  WhisperTabBar(this.preservatedPostIds,this.likedPostIds);
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
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            tabs: tabBarElements.map((tabBarElement) {
              return Tab(
                text: tabBarElement.title
              );
            }).toList()
          ),
        ),
        body: TabBarView(
          children: [
            FeedsPage(preservatedPostIds,likedPostIds),
            RecommendersPage(preservatedPostIds,likedPostIds)
            
          ],
        ),
        
      )
    );
  }
}