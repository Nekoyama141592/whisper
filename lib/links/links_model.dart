// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/constants/others.dart';
// domain
import 'package:whisper/domain/whisper_link/whisper_link.dart';
// pages
import 'package:whisper/links/links_page.dart';

final linksProvider = ChangeNotifierProvider(
  (ref) => LinksModel()
);
class LinksModel extends ChangeNotifier {
  List<WhisperLink> whisperLinks = [];
  List<TextEditingController> controllers = [];

  void init({ required BuildContext context  ,required List<dynamic> linkMaps }) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LinksPage() ));
    linkMaps.forEach((linkMap) {
      final WhisperLink whisperLink = fromMapToWhisperLink(whisperLink: linkMap as Map<String,dynamic>);
      whisperLinks.add(whisperLink);
      final TextEditingController textEditingController = TextEditingController(text: whisperLink.label);
      controllers.add(textEditingController);
    });
    notifyListeners();
  }
}