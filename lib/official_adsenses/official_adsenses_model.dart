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
import 'package:whisper/constants/counts.dart';

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
      await FirebaseFirestore.instance.collection('officialAdsenses').limit(30).get().then((qshot) {
        qshot.docs.forEach((doc) { officialAdsenseDocs.add(doc); } );
      });
      if (officialAdsenseDocs.isNotEmpty) {
        Timer.periodic(Duration(seconds: officialAdsenseIntervalSeconds), (_) async {
          randIndex = rand.nextInt(officialAdsenseDocs.length);
          final result = officialAdsenseDocs[randIndex];
          showTopFlash(context, result);
        });
      }
    }
  }

  void showTopFlash(BuildContext context, DocumentSnapshot<Map<String,dynamic>> result,{ bool persistent = true,EdgeInsets margin = EdgeInsets.zero}) {
    showFlash(
      context: context, 
      persistent: persistent,
      duration: Duration(seconds: officialAdsenseDisplaySeconds),
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
            final String link = result['link'];
            await controller.dismiss();
            if (await canLaunch(link)) {
              await launch(link);
            } else {
              context.showToast('このURLは不適です');
            }
          },
          child: DefaultTextStyle(
            style: TextStyle(fontWeight: FontWeight.bold), 
            child: FlashBar(
              title: Text(
                result['title'],
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
              content: Text(
                result['subTitle'],
                style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor
                ),
              ),
              indicatorColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.info),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: Text(
                  'DISMISS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
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