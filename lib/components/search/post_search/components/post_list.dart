// material
import 'package:flutter/material.dart';
// constants
import 'package:algolia/algolia.dart';
// component
import 'post_result.dart';

class PostList extends StatelessWidget {

  const PostList({
    Key? key,
    required this.results
  }) : super(key: key);

  final List<AlgoliaObjectSnapshot> results;
  
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int i) =>
        PostResult(result: results[i].data)
      )
    );
  }
}