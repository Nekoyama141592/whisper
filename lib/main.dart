import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'themes/themes.dart';
import 'parts/main_bottom_navigation_bar.dart';
import 'package:whisper/constants/tab_bar_elements.dart';

import 'auth/login/login_page.dart';

import 'package:whisper/parts/posts/feeds/feeds_page.dart';
import 'package:whisper/parts/posts/recommenders/recommenders_page.dart';
import 'package:whisper/parts/whisper_drawer.dart';

import 'package:whisper/parts/posts/posts_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: currentUser == null ? 
      LoginPage()
      : MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _postsProvider = watch(postsProvider);
    return DefaultTabController(
      length: tabBarElements.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Whisper'),
          bottom: TabBar(
            tabs: tabBarElements.map((tabBarElement) {
              return Tab(
                text: tabBarElement.title
              );
            }).toList()
          ),
        ),
        body: TabBarView(
          children: [
            FeedsPage(postsProvider: _postsProvider),
            RecommendersPage(postsProvider: _postsProvider)
          ],
        ),
        drawer: WhisperDrawer(),
        bottomNavigationBar: MainBottomNavigationbar(),
      ),
    );
  }
}
