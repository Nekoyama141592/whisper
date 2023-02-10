// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/home_tab_bar_elements.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/notification_icon.dart';
import 'package:whisper/details/whisper_drawer.dart';
// pages
import 'package:whisper/views/main/home/feeds/feeds_page.dart';
import 'package:whisper/views/main/home/recommenders/recommenders_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/themes/themes_model.dart';

class Home extends ConsumerWidget {

  const Home({
    Key? key,
    required this.mainModel,
    required this.themeModel,
  }) : super(key: key);
  
  final MainModel mainModel;
  final ThemeModel themeModel;
  void initState() {
    super.createState();
  }
  @override
  Widget build(BuildContext context,WidgetRef ref ) {
    return DefaultTabController(
      length: tabBarElements.length, 
      child: Scaffold(
        appBar: AppBar(
          title: whiteBoldEllipsisHeaderText(context: context, text: "Whisper"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(defaultPadding(context: context))
            )
          ),
          actions: [
            NotificationIcon(
              mainModel: mainModel, 
              themeModel: themeModel,
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
            RecommendersPage(mainModel: mainModel ),
            FeedsPage(mainModel: mainModel ),
          ],
        ),
        
      )
    );
  }
}