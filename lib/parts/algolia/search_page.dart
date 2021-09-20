import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/algolia/constants/tab_bar_elements.dart';
import 'package:whisper/parts/components/whisper_drawer.dart';
import 'package:whisper/main_model.dart';

import 'package:whisper/parts/algolia/user_search/user_search_page.dart';
import 'package:whisper/parts/algolia/post_search/post_search_page.dart';
// import 'search_model.dart';

class SearchPage extends ConsumerWidget {

  SearchPage(this.mainProvider);
  final MainModel mainProvider;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    // final _searchProvider = watch(searchProvider);
    // final searchController = TextEditingController.fromValue(
    //   TextEditingValue(
    //     text: _searchProvider.searchTerm,
    //     selection: TextSelection.collapsed(
    //       offset: _searchProvider.searchTerm.length
    //     )
    //   )
    // );
    return SafeArea(
      child: DefaultTabController(
        length: tabBarElements.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Search'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30)
              )
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down),
                onPressed: () {
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
          drawer: WhisperDrawer(
            mainProvider, 
          ),
          body: 
          TabBarView(
            children: [
              PostSearchPage(),
              UserSearchPage(),
            ]
          )
        ),
      ),
    );
  }
}