import 'package:flutter/material.dart';

import 'package:algolia/algolia.dart';

import 'post_result.dart';

class PostList extends StatelessWidget {

  PostList(this.results);
  final List<AlgoliaObjectSnapshot> results;
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int i) =>
        PostResult(
          results[i].data
        )
      )
    );
  }
}