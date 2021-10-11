// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// constants
import 'themes/themes.dart';
//components
import 'package:whisper/details/loading.dart';
import 'components/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar.dart';
import 'package:whisper/components/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar_model.dart';
// pages
import 'package:whisper/components/home/home.dart';
import 'auth/signup/signup_page.dart';
import 'package:whisper/auth/verify/verify_page.dart';
import 'package:whisper/components/search/search_page.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/components/add_post/other_pages/which_type.dart';
import 'package:whisper/components/user_show/user_show_page.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';


void main() async {
  await dotenv.load(fileName: '.env',);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final themeModel = watch(themeProvider);
    return MaterialApp(
      title: 'Whisper',
      debugShowCheckedModeBanner: false,
      theme: themeModel.isDarkTheme ? darkThemeData(context) : lightThemeData(context),
      home: currentUser == null ? 
      SignupPage()
      : currentUser!.emailVerified ?
      MyHomePage(
        themeModel: themeModel,
      ) : VerifyPage()
    );
  }
}

class MyHomePage extends ConsumerWidget {

  const MyHomePage({
    Key? key,
    required this.themeModel
  }) : super(key: key);

  final ThemeModel themeModel;
  @override  
  Widget build(BuildContext context, ScopedReader watch) {
    final mainModel = watch(mainProvider);
    final whisperBottomNavigationbarModel = watch(whisperBottomNavigationbarProvider);
    final likedPostIds = mainModel.likedPostIds;
    final bookmarkedPostIds = mainModel.bookmarkedPostIds;
    final likedCommentIds = mainModel.likedCommentIds;
    final likedComments = mainModel.likedComments;
    final bookmarks = mainModel.bookmarks;
    final likes = mainModel.likes;
    final replyNotifications = mainModel.replyNotifications;
    final readPostIds = mainModel.readPostIds;

    return Scaffold(
      body: mainModel.isLoading ?
      Loading()
      : PageView(
        controller: whisperBottomNavigationbarModel.pageController,
        onPageChanged: (index){
          whisperBottomNavigationbarModel.onPageChanged(index);
        },
        children: [
          Home(
            mainModel: mainModel, 
            themeModel: themeModel, 
            bookmarkedPostIds: bookmarkedPostIds, 
            likedPostIds: likedPostIds,
            likedCommentIds: likedCommentIds,
            likedComments: likedComments,
            bookmarks: bookmarks,
            likes: likes,
            replyNotifications: replyNotifications,
            readPostIds: readPostIds,
            readPosts: mainModel.readPosts,
            readNotificationIds: mainModel.readNotificationsIds
          ),
          SearchPage(
            mainModel: mainModel,
            themeModel: themeModel,
          ),
          WhichType(currentUserDoc: mainModel.currentUserDoc),
          BookmarksPage(mainModel: mainModel),
         UserShowPage(passiveUserDoc: mainModel.currentUserDoc, mainModel: mainModel)
        ],
      ),
      bottomNavigationBar: WhisperBottomNavigationbar(model: whisperBottomNavigationbarModel),
    );
  }
}