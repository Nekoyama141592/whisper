import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/main_model.dart';
import 'package:whisper/details/loading.dart';

import 'themes/themes.dart';
import 'components/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar.dart';


import 'auth/signup/signup_page.dart';

import 'package:whisper/components/home/home.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
import 'package:whisper/components/search/search_page.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/components/add_post/other_pages/which_type.dart';
import 'package:whisper/components/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env',);
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
      SignupPage()
      : MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final _mainProvider = watch(mainProvider);
    final _provider = watch(whisperBottomNavigationbarProvider);
    return Scaffold(
      body: _mainProvider.isLoading ?
      Loading()
      : PageView(
        controller: _provider.pageController,
        onPageChanged: (index){
          _provider.onPageChanged(index);
        },
        children: [
          Home(
            _mainProvider,
            _mainProvider.preservatedPostIds,
            _mainProvider.likedPostIds
          ),
          SearchPage(
            _mainProvider
          ),
          WhichType(currentUserDoc: _mainProvider.currentUserDoc),
          BookmarksPage(
            _mainProvider.currentUserDoc,
            _mainProvider.preservatedPostIds, 
            _mainProvider.likedPostIds
          ),
          UserShowPage(
            _mainProvider.currentUserDoc,
            _mainProvider.currentUserDoc, 
            _mainProvider.preservatedPostIds, 
            _mainProvider.likedPostIds,
            _mainProvider.followingUids
          )
        ],
      ),
      bottomNavigationBar: WhisperBottomNavigationbar(_provider),
    );
  }
}