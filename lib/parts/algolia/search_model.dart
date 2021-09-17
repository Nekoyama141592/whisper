import 'dart:async';

import 'package:flutter/material.dart';

import 'package:algolia/algolia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'AlgoliaApplication.dart';

final searchProvider = ChangeNotifierProvider(
  (ref) => SearchModel()
);

class SearchModel extends ChangeNotifier {
  final Algolia algoliaApp = AlgoliaApplication.algolia;
  String searchTerm = "";
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
  Future operation(String input) async {
    startLoading();
    results = [];
    AlgoliaQuery query = algoliaApp.instance.index('Posts').query(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    // Checking if has [AlgoliaQuerySnapshot]
    querySnap.hits.forEach((hit) {
      results.add(hit);
    });
    print('Hits count: ${querySnap.nbHits}');
    print(results.length.toString() + 'resultsLength');
    endLoading();
    // return querySnap;
  }

}