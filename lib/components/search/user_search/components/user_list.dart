// material
import 'package:flutter/material.dart';
// constants
import 'package:algolia/algolia.dart';
// components
import 'package:whisper/components/search/user_search/components/user_result.dart';
// model
import 'package:whisper/main_model.dart';

class UserList extends StatelessWidget {

  UserList({
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
        // UserResult(result: results[i].data)
        UserResult(result: results[i].data, mainModel: mainModel)
      )
    );
  }
}