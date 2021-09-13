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

  List<AlgoliaObjectSnapshot> results = [];

  Future<AlgoliaQuerySnapshot> operation(String input) async {
    results = [];
    AlgoliaQuery query = algoliaApp.instance.index('Posts').query(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    // Checking if has [AlgoliaQuerySnapshot]
    print('Hits count: ${querySnap.nbHits}');
    notifyListeners();
    return querySnap;
  }

}