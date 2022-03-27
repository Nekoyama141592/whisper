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
import 'package:whisper/domain/official_advertisement_tap/official_advertisement_tap.dart';

final officialAdvertisementsProvider = ChangeNotifierProvider(
  (ref) => OfficialAdvertisementsModel()
);

class OfficialAdvertisementsModel extends ChangeNotifier {
  bool isPlayed = false;
  bool isShowing = false;
  final Random rand = Random();
  int randIndex = 0;
  late OfficialAdvertisementConfig config;
  List<DocumentSnapshot<Map<String,dynamic>>> officialAdvertisementDocs = [];
  
  Future<void> onPlayButtonPressed() async {
    if (!isPlayed) {
      isPlayed = true;
      final qshot = await returnOfficialAdvertisementConfigColRef.get();
      if (qshot.docs.isNotEmpty) {
        config = OfficialAdvertisementConfig.fromJson(qshot.docs.first.data());
      }
      config = OfficialAdvertisementConfig(createdAt: Timestamp.now(), displaySeconds: 15, intervalSeconds: 20, updatedAt: Timestamp.now() );
      // await FirebaseFirestore.instance.collection(officialAdvertisementsFieldKey).orderBy(createdAtFieldKey,descending: true).get().then((qshot) {
      //   qshot.docs.forEach((doc) { officialAdvertisementDocs.add(doc); } );
      // });

      if (officialAdvertisementDocs.isNotEmpty) {
        Timer.periodic(Duration(seconds: config.intervalSeconds), (_) async {
          randIndex = rand.nextInt(officialAdvertisementDocs.length);
          final resultDoc = officialAdvertisementDocs[randIndex];
          final OfficialAdvertisement result = OfficialAdvertisement.fromJson(resultDoc.data()!);
          if (canShowAdvertisement(officialAdvertisement: result)) {
            final String officialAdvertisementId = resultDoc.id;
            showTopToast(officialAdvertisement: result);
            await FlutterClipboard.copy(result.url);
            await makeImpressionDoc(officialAdvertisementId: officialAdvertisementId);
          }
        });
      }
    }
  }

  void showTopToast({ required OfficialAdvertisement officialAdvertisement }) {
    Fluttertoast.showToast(
      msg: officialAdvertisement.title,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: kContentColorLightTheme,
      textColor: Colors.white
    );
  }

  Future<void> makeImpressionDoc({ required String officialAdvertisementId }) async {
    final String uid = firebaseAuthCurrentUser!.uid;
    final OfficialAdvertisementImpression officialAdvertisementImpression = OfficialAdvertisementImpression(createdAt: Timestamp.now(), uid: uid,officialAdvertisementId: officialAdvertisementId );
    final String officialAdvertisementImpressionId = returnOfficialAdvertisementImpressionId(uid: uid );
    await returnOfficialAdvertisementImpressionDocRef(officialAdvertisementId: officialAdvertisementId, officialAdvertisementImpressionId: officialAdvertisementImpressionId).set(officialAdvertisementImpression.toJson());
  }
  Future<void> makeTapDoc({ required String officialAdvertisementId }) async {
    final String uid = firebaseAuthCurrentUser!.uid;
    final OfficialAdvertisementTap officialAdvertisementTap = OfficialAdvertisementTap(createdAt: Timestamp.now(), uid: uid,officialAdvertisementId: officialAdvertisementId );
    final String officialAdvertisementTapId = returnOfficialAdvertisementTapId(uid: uid);
    await returnOfficialAdvertisementTapDocRef(officialAdvertisementId: officialAdvertisementId, officialAdvertisementTapId: officialAdvertisementTapId).set(officialAdvertisementTap.toJson());
  }
}