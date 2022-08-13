// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/ints.dart';
import 'package:whisper/constants/lists.dart';
import 'package:whisper/constants/enums.dart';
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/l10n/l10n.dart';

final searchProvider = ChangeNotifierProvider(
  (ref) => UserSearchModel()
);
class UserSearchModel extends ChangeNotifier {

  String searchTerm = '';
  bool isLoading = false;
  // enum
  final BasicDocType basicDocType = BasicDocType.searchedUser;
  
  List<DocumentSnapshot<Map<String,dynamic>>> results = [];
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> operation({ required BuildContext context ,required List<String> mutesUids, required List<String> blocksUids}) async {
    if (searchTerm.length > maxSearchLength ) {
      final x = maxSearchLength.toString();
      final L10n l10n = returnL10n(context: context)!;
      showBasicFlutterToast(context: context, msg: l10n.searchLimitMsg(x) );
    } else if (searchTerm.isNotEmpty) {
      startLoading();
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnUserSearchQuery(searchWords: searchWords);
      await processBasicDocs(basicDocType: basicDocType,query: query, docs: results);
      if (searchTerm.length == uidLength) {
        final x = await returnUserDocRef(uid: searchTerm ).get();
        if (x.exists == true) {
          results.insert(0, x);
        }
      }
      endLoading();
    }
  }
}