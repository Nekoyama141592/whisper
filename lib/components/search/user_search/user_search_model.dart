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

  Future<void> operation({ required BuildContext context ,required List<dynamic> mutesUids, required List<dynamic> blocksUids}) async {
    if (searchTerm.length > maxSearchLength ) {
      showBasicFlutterToast(context: context, msg: maxSearchLength.toString() + '文字未満で検索してください' );
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