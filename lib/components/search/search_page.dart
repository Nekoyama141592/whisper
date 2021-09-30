// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/components/search/constants/tab_bar_elements.dart';
import 'package:whisper/details/whisper_drawer.dart';
// pages
import 'package:whisper/components/search/user_search/user_search_page.dart';
import 'package:whisper/components/search/post_search/post_search_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class SearchPage extends ConsumerWidget {

  const SearchPage({
    Key? key,
    required this.mainModel,
    required this.themeModel
  }) : super(key: key);

  final MainModel mainModel;
  final ThemeModel themeModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    return DefaultTabController(
      length: tabBarElements.length,
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
        drawer: WhisperDrawer(mainModel: mainModel,themeModel: themeModel),
        body: 
        TabBarView(
          children: [
            PostSearchPage(),
            UserSearchPage(),
          ]
        )
      ),
    );
  }
}