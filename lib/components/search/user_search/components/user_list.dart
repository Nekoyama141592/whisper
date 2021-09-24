import 'package:flutter/material.dart';

import 'package:algolia/algolia.dart';

import 'package:whisper/components/search/user_search/components/user_result.dart';

class UserList extends StatelessWidget {

  UserList(this.results);
  final List<AlgoliaObjectSnapshot> results;
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int i) =>
        UserResult(
          results[i].data
        )
      )
    );
  }
}