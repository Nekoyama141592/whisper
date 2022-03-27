// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/search/constants/tab_bar_elements.dart';
import 'package:whisper/details/whisper_drawer.dart';
// pages
import 'package:whisper/components/search/user_search/user_search_page.dart';
import 'package:whisper/components/search/ranking/user_ranking_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';
// main.dart
import 'package:whisper/main.dart';

class SearchPage extends StatelessWidget {

  const SearchPage({
    Key? key,
    required this.mainModel,
    required this.themeModel
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;

  @override  
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabBarElements.length,
      child: ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Search'),
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
          drawer: WhisperDrawer(mainModel: mainModel,themeModel: themeModel ),
          body: 
          TabBarView(
            children: [
              UserSearchPage(mainModel: mainModel),
              UserRankingPage(mainModel: mainModel),
            ]
          )
        ),
      ),
    );
  }
}