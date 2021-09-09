import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:whisper/main_model.dart';

import 'themes/themes.dart';
import 'parts/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar.dart';


import 'auth/signup/signup_page.dart';

import 'package:whisper/parts/whisper_tab_bar.dart';
import 'package:whisper/parts/whisper_drawer.dart';

import 'package:whisper/parts/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar_model.dart';
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
      body: 
      PageView(
        controller: _provider.pageController,
        onPageChanged: (index){
          _provider.onPageChanged(index);
        },
        children: [
          WhisperTabBar(
            _mainProvider,
            _mainProvider.preservatedPostIds,
            _mainProvider.likedPostIds
          ),
          Scaffold(
            body: Text('add')
          ),
          
          Scaffold(body: Text('sample'))
        ],
      ),
      bottomNavigationBar: WhisperBottomNavigationbar(_provider),
    );
  }
}