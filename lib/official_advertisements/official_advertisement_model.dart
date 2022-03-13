// dart
import 'dart:math';
import 'dart:async';
// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:clipboard/clipboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
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
  final Random rand = Random();
  int randIndex = 0;
  late OfficialAdvertisementConfig config;
  List<DocumentSnapshot<Map<String,dynamic>>> officialAdvertisementDocs = [];

  Future<void> onPlayButtonPressed(BuildContext context) async {
    if (!isPlayed) {
      isPlayed = true;
      final qshot = await returnOfficialAdvertisementConfigColRef.get();
      if (qshot.docs.isNotEmpty) {
        config = OfficialAdvertisementConfig.fromJson(qshot.docs.first.data());
      }
      await FirebaseFirestore.instance.collection(officialAdvertisementsFieldKey).orderBy(createdAtFieldKey,descending: true).limit(oneTimeReadCount).get().then((qshot) {
        qshot.docs.forEach((doc) { officialAdvertisementDocs.add(doc); } );
      });
      if (officialAdvertisementDocs.isNotEmpty) {
        
        Timer.periodic(Duration(seconds: config.intervalSeconds), (_) async {
          randIndex = rand.nextInt(officialAdvertisementDocs.length);
          final resultDoc = officialAdvertisementDocs[randIndex];
          final OfficialAdvertisement result = OfficialAdvertisement.fromJson(resultDoc.data()!);
          final String officialAdvertisementId = resultDoc.id;
          showTopFlash(context: context, officialAdvertisementId: officialAdvertisementId,result: result, config: config,margin: EdgeInsets.all(8.0));
          await makeImpressionDoc(officialAdvertisementId: officialAdvertisementId);
        });
      }
    }
  }

  void showTopFlash({ required BuildContext context, required String officialAdvertisementId ,required OfficialAdvertisement result, required OfficialAdvertisementConfig config,bool persistent = true,EdgeInsets margin = EdgeInsets.zero}) {
    showFlash(
      context: context, 
      persistent: persistent,
      duration: Duration(seconds: config.displaySeconds),
      builder: (_, controller) {
        return Flash(
          controller: controller, 
          margin: margin,
          backgroundColor: Theme.of(context).focusColor,
          behavior: FlashBehavior.fixed,
          position: FlashPosition.top,
          borderRadius: BorderRadius.circular(8.0),
          borderColor: Theme.of(context).highlightColor,
          boxShadows: kElevationToShadow[8],
          forwardAnimationCurve: Curves.easeInCirc,
          reverseAnimationCurve: Curves.bounceIn,
          onTap: () async {
            final String link = result.link;
            await controller.dismiss();
            await FlutterClipboard.copy(link).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('リンクをコピーしました')));
            });
            await Future.delayed(Duration(milliseconds: 500));
            if (await canLaunch(link)) {
              await launch(link);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('このURLは不適切です')));
            }
            await makeTapDoc(officialAdvertisementId: officialAdvertisementId);
          },
          child: DefaultTextStyle(
            style: TextStyle(fontWeight: FontWeight.bold), 
            child: FlashBar(
              title: Text(
                result.title,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
              content: Text(
                result.subTitle,
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
              indicatorColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.info,color: Theme.of(context).primaryColor,),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: Text(
                  'DISMISS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
              
            )
          )
        );
      }
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