// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:whisper/components/bookmarks/other_pages/bookmark_labels_page.dart';
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
import 'package:whisper/components/add_post/other_pages/which_type.dart';
import 'package:whisper/components/my_profile/my_profile_page.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/themes/themes_model.dart';

Future<void> main() async {
  // // await dotenv.load(fileName: '.env',);
  // // await JustAudioBackground.init(
  // //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  // //   androidNotificationChannelName: 'Audio playback',
  // //   androidNotificationOngoing: true,
  // // );
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    // Crashlytics
    // DartのエラーをCrashlyticsに報告する
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(ProviderScope(child: MyApp()));
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends ConsumerWidget {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModel = ref.watch(themeProvider);
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
  Widget build(BuildContext context, WidgetRef ref) {
    final mainModel = ref.watch(mainProvider);
    final whisperBottomNavigationbarModel = ref.watch(whisperBottomNavigationbarProvider);
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
          ),
          SearchPage(
            mainModel: mainModel,
            themeModel: themeModel,
          ),
          WhichType(mainModel: mainModel),
          BookmarkLabelsPage(mainModel: mainModel),
          MyProfilePage(mainModel: mainModel),
        ],
      ),
      bottomNavigationBar: WhisperBottomNavigationbar(model: whisperBottomNavigationbarModel),
    );
  }
}