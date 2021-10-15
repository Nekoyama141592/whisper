import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algolia/algolia.dart';
import 'package:whisper/components/search/constants/AlgoliaApplication.dart';

final searchProvider = ChangeNotifierProvider(
  (ref) => UserSearchModel()
);
class UserSearchModel extends ChangeNotifier {

  final Algolia algoliaApp = AlgoliaApplication.algolia;
  String searchTerm = '';
  bool isLoading = false;
  
  List<AlgoliaObjectSnapshot> results = [];
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }
  Future operation(List<String> mutesUids,List<dynamic> blockingUids) async {
    startLoading();
    results = [];
    AlgoliaQuery query = algoliaApp.instance.index('Users').query(searchTerm);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = querySnap.hits;
    hits.sort((a,b) => b.data['followerUids'].length.compareTo(a.data['followerUids'].length));
    hits.forEach((hit) {
      if (!mutesUids.contains(hit.data['uid']) && !blockingUids.contains(hit.data['uid'])) {
        results.add(hit);
      }
    });
    endLoading();
  }
}