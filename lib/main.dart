// dart
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:whisper/views/bookmark_categories/bookmark_categories_page.dart';
// constants
import 'views/themes/themes.dart';
//components
import 'package:whisper/details/loading.dart';
import 'views/main/whisper_bottom_navigation_bar/whisper_bottom_navigation_bar.dart';
import 'package:whisper/models/main/whisper_bottom_navigation_bar_model.dart';
// pages
import 'package:whisper/views/main/home/home.dart';
import 'views/auth/signup/signup_page.dart';
import 'package:whisper/views/auth/verify/verify_page.dart';
import 'package:whisper/views/main/search/search_page.dart';
import 'package:whisper/views/main/which_type/which_type.dart';
import 'package:whisper/views/main/my_profile/my_profile_page.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/themes/themes_model.dart';
// locaization
import 'package:whisper/l10n/l10n.dart';

Future<void> main() async {
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
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          final _locale = Locale(locale.languageCode);
          if (supportedLocales.contains(_locale)) {
            return _locale;
          }
        }
        return supportedLocales.first;
      },
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
        onPageChanged: (index) => whisperBottomNavigationbarModel.onPageChanged(index),
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
          BookmarkCategoriesPage(mainModel: mainModel),
          MyProfilePage(mainModel: mainModel),
        ],
      ),
      bottomNavigationBar: WhisperBottomNavigationbar(model: whisperBottomNavigationbarModel),
    );
  }
}