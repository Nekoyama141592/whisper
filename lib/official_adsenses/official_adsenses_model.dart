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
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/official_adsense/official_adsense.dart';

final officialAdsensesProvider = ChangeNotifierProvider(
  (ref) => OfficialAdsensesModel()
);

class OfficialAdsensesModel extends ChangeNotifier {
  bool isPlayed = false;
  final Random rand = Random();
  int randIndex = 0;
  List<DocumentSnapshot<Map<String,dynamic>>> officialAdsenseDocs = [];

  Future<void> onPlayButtonPressed(BuildContext context) async {
    if (!isPlayed) {
      isPlayed = true;
      await FirebaseFirestore.instance.collection(officialAdsensesFieldKey).orderBy(createdAtFieldKey,descending: false).limit(oneTimeReadCount).get().then((qshot) {
        qshot.docs.forEach((doc) { officialAdsenseDocs.add(doc); } );
      });
      if (officialAdsenseDocs.isNotEmpty) {
        final OfficialAdsense first = fromMapToOfficialAdsense(officialAdsenseMap: officialAdsenseDocs.first.data()!);
        Timer.periodic(Duration(seconds: first.intervalSeconds), (_) async {
          randIndex = rand.nextInt(officialAdsenseDocs.length);
          final OfficialAdsense result = fromMapToOfficialAdsense(officialAdsenseMap: officialAdsenseDocs[randIndex].data()!);
          showTopFlash(context: context, result: result, firstAdsense: first,margin: EdgeInsets.all(8.0));
        });
      }
    }
  }

  void showTopFlash({ required BuildContext context, required OfficialAdsense result, required OfficialAdsense firstAdsense,bool persistent = true,EdgeInsets margin = EdgeInsets.zero}) {
    showFlash(
      context: context, 
      persistent: persistent,
      duration: Duration(seconds: firstAdsense.displaySeconds),
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
}