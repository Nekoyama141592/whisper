import 'package:flutter/material.dart';

import 'components/tab_bar_elements.dart';

import 'package:whisper/main_model.dart';
import 'package:whisper/parts/whisper_drawer.dart';

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
          preservatedPostIds,
          likedPostIds
        ),
        body: TabBarView(
          children: [
            Container(),
            Container(),
          ]
        ),
      ),
    );
  }
}