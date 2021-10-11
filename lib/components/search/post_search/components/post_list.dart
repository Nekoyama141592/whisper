// material
import 'package:flutter/material.dart';
// constants
import 'package:algolia/algolia.dart';
import 'package:whisper/main_model.dart';
// component
import 'post_result.dart';

class PostList extends StatelessWidget {

  const PostList({
    Key? key,
    required this.results,
    required this.mainModel
  }) : super(key: key);

  final List<AlgoliaObjectSnapshot> results;
  final MainModel mainModel;
  
  @override 
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, int i) =>
        PostResult(result: results[i].data,mainModel: mainModel,)
      )
    );
  }
}