// dart
import 'dart:math';
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/official_advertisement/official_advertisement.dart';
import 'package:whisper/domain/official_advertisement_config/official_advertisement_config.dart';
import 'package:whisper/domain/official_advertisement_impression/official_advertisement_impression.dart';

final themeProvider = ChangeNotifierProvider(
  (ref) => ThemeModel()
);

class ThemeModel extends ChangeNotifier {
  // theme
  late SharedPreferences preferences;
  bool isDarkTheme = true;
  // ad
  final Random rand = Random();
  int randIndex = 0;
  late OfficialAdvertisementConfig config;
  List<DocumentSnapshot<Map<String,dynamic>>> officialAdvertisementDocs = [];

  ThemeModel() {
    init();
  }

  void init() async {
    // theme
    preferences = await SharedPreferences.getInstance();
    isDarkTheme = preferences.getBool(isDarkThemePrefsKey) ?? true;
    notifyListeners();
    // ad
    final configDoc = await returnOfficialAdvertisementConfigDocRef.get();
    config = OfficialAdvertisementConfig.fromJson(configDoc.data()!);
    final qshot = await returnOfficialAdvertisementsColRef().get();
    officialAdvertisementDocs = qshot.docs;
    if (officialAdvertisementDocs.isNotEmpty) {
      Timer.periodic(Duration(seconds: config.intervalSeconds), (_) async {
        randIndex = rand.nextInt(officialAdvertisementDocs.length);
        final resultDoc = officialAdvertisementDocs[randIndex];
        final OfficialAdvertisement result = OfficialAdvertisement.fromJson(resultDoc.data()!);
        if (canShowAdvertisement(officialAdvertisement: result)) {
          final String officialAdvertisementId = resultDoc.id;
          await showTopToast(officialAdvertisement: result);
          await FlutterClipboard.copy(result.url);
          await makeImpressionDoc(officialAdvertisementId: officialAdvertisementId);
        }
      });
    }
  }
  
  void setIsDartTheme(value) async {
    isDarkTheme = value;
    notifyListeners();
    await preferences.setBool(isDarkThemePrefsKey, value);
  }
  // ad
  Future<void> showTopToast({ required OfficialAdvertisement officialAdvertisement }) async {
    final backGroundColorLightTheme = hexStringToColor(hexString: officialAdvertisement.backGroundHex16LightTheme).withOpacity(officialAdvertisement.backGroundOpacity);
    final textColorLightTheme = hexStringToColor(hexString: officialAdvertisement.textHex16LightTheme).withOpacity(officialAdvertisement.textOpacity);
    final backGroundColorDarkTheme = hexStringToColor(hexString: officialAdvertisement.backGroundHex16DarkTheme).withOpacity(officialAdvertisement.backGroundOpacity);
    final textColorDarkTheme = hexStringToColor(hexString: officialAdvertisement.textHex16DarkTheme).withOpacity(officialAdvertisement.textOpacity);
    await Fluttertoast.showToast(
      msg: officialAdvertisement.title,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: config.timeInSecForIosWeb,
      backgroundColor: isDarkTheme ? backGroundColorDarkTheme : backGroundColorLightTheme,
      textColor: isDarkTheme ? textColorDarkTheme : textColorLightTheme
    );
  }

  Future<void> makeImpressionDoc({ required String officialAdvertisementId }) async {
    final String uid = firebaseAuthCurrentUser()!.uid;
    final OfficialAdvertisementImpression officialAdvertisementImpression = OfficialAdvertisementImpression(createdAt: Timestamp.now(),isDarkTheme: isDarkTheme ,uid: uid,officialAdvertisementId: officialAdvertisementId );
    final String officialAdvertisementImpressionId = returnOfficialAdvertisementImpressionId(uid: uid );
    await returnOfficialAdvertisementImpressionDocRef(officialAdvertisementId: officialAdvertisementId, officialAdvertisementImpressionId: officialAdvertisementImpressionId).set(officialAdvertisementImpression.toJson());
  }

}