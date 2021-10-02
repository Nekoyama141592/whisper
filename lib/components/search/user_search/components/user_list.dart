// material
import 'package:flutter/material.dart';
// constants
import 'package:algolia/algolia.dart';
// components
import 'package:whisper/components/search/user_search/components/user_result.dart';

class UserList extends StatelessWidget {

  UserList({
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
        UserResult(result: results[i].data)
      )
    );
  }
}