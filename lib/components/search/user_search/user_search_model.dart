// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:algolia/algolia.dart';
// constants
import 'package:whisper/constants/strings.dart';
// algolia
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
  Future operation(List<dynamic> mutesUids,List<dynamic> blockingUids) async {
    startLoading();
    results = [];
    AlgoliaQuery query = algoliaApp.instance.index('Users').query(searchTerm);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> hits = querySnap.hits;
    hits.sort((a,b) => b.data[followerCountKey].compareTo(a.data[followerCountKey]));
    hits.forEach((hit) {
      if (!mutesUids.contains(hit.data[uidKey]) && !blockingUids.contains(hit.data[uidKey])) {
        results.add(hit);
      }
    });
    endLoading();
  }
}