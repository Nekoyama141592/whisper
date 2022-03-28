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
// constants
import 'package:whisper/constants/bools.dart';
import 'package:whisper/constants/colors.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// domain
import 'package:whisper/domain/official_advertisement/official_advertisement.dart';
import 'package:whisper/domain/official_advertisement_config/official_advertisement_config.dart';
import 'package:whisper/domain/official_advertisement_impression/official_advertisement_impression.dart';

final officialAdvertisementsProvider = ChangeNotifierProvider(
  (ref) => OfficialAdvertisementsModel()
);

class OfficialAdvertisementsModel extends ChangeNotifier {
  bool isPlayed = false;
  final Random rand = Random();
  int randIndex = 0;
  late OfficialAdvertisementConfig config;
  List<DocumentSnapshot<Map<String,dynamic>>> officialAdvertisementDocs = [];
  
  OfficialAdvertisementsModel() {
    init();
  }
  Future<void> init() async {
    if (!isPlayed) {
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
  }

  Future<void> showTopToast({ required OfficialAdvertisement officialAdvertisement }) async {
    final bColor = Color.fromRGBO(officialAdvertisement.backgroundRed, officialAdvertisement.backgroundGreen, officialAdvertisement.backgroundBlue, officialAdvertisement.backgroundOpacity);
    await Fluttertoast.showToast(
      msg: officialAdvertisement.title,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: bColor,
      textColor: officialAdvertisement.isWhiteText ? Colors.white : Colors.black
    );
  }

  Future<void> makeImpressionDoc({ required String officialAdvertisementId }) async {
    final String uid = firebaseAuthCurrentUser()!.uid;
    final OfficialAdvertisementImpression officialAdvertisementImpression = OfficialAdvertisementImpression(createdAt: Timestamp.now(), uid: uid,officialAdvertisementId: officialAdvertisementId );
    final String officialAdvertisementImpressionId = returnOfficialAdvertisementImpressionId(uid: uid );
    await returnOfficialAdvertisementImpressionDocRef(officialAdvertisementId: officialAdvertisementId, officialAdvertisementImpressionId: officialAdvertisementImpressionId).set(officialAdvertisementImpression.toJson());
  }
}