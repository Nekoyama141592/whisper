// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/components/home/constants/tab_bar_elements.dart';
import 'package:whisper/constants/others.dart';
// components
import 'package:whisper/details/notification_icon.dart';
import 'package:whisper/details/whisper_drawer.dart';
// pages
import 'package:whisper/components/home/feeds/feeds_page.dart';
import 'package:whisper/components/home/recommenders/recommenders_page.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

class Home extends ConsumerWidget {

  const Home({
    Key? key,
    required this.mainModel,
    required this.themeModel,
  }) : super(key: key);
  
  final MainModel mainModel;
  final ThemeModel themeModel;

  @override
  Widget build(BuildContext context,WidgetRef ref ) {
    final l10n = returnL10n(context: context);
    return DefaultTabController(
      length: tabBarElements.length, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n!.whisper,style: TextStyle(color: Colors.white), ),
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
            FeedsPage(mainModel: mainModel ),
            RecommendersPage(mainModel: mainModel )
          ],
        ),
        
      )
    );
  }
}