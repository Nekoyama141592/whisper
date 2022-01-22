// material
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:algolia/algolia.dart';
import 'package:whisper/constants/lists.dart';
// constants
import 'package:whisper/constants/voids.dart';
import 'package:whisper/constants/strings.dart';
import 'package:whisper/constants/others.dart';
// algolia
// import 'package:whisper/components/search/constants/AlgoliaApplication.dart';

final searchProvider = ChangeNotifierProvider(
  (ref) => UserSearchModel()
);
class UserSearchModel extends ChangeNotifier {

  // final Algolia algoliaApp = AlgoliaApplication.algolia;
  String searchTerm = '';
  bool isLoading = false;
  
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
    if (searchTerm.length < 64) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('64文字未満で検索してください')));
    } else {
      startLoading();
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnSearchQuery(collectionKey: usersKey, searchWords: searchWords);
      await processBasicDocs(query: query, docs: results);
      endLoading();
    }
  }
  // Future operation(List<dynamic> mutesUids,List<dynamic> blocksUids) async {
  //   startLoading();
  //   results = [];
  //   AlgoliaQuery query = algoliaApp.instance.index('Users').query(searchTerm);
  //   AlgoliaQuerySnapshot querySnap = await query.getObjects();
  //   List<AlgoliaObjectSnapshot> hits = querySnap.hits;
  //   hits.forEach((hit) {
  //     final whisperUser = fromMapToWhisperUser(userMap: hit.data);
  //     if (!mutesUids.contains(whisperUser.uid) && !blocksUids.contains(whisperUser.uid)) {
  //       results.add(hit);
  //     }
  //   });
  //   endLoading();
  // }
}