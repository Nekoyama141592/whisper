// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
// constants
import 'package:algolia/algolia.dart';
// components
import 'package:whisper/details/search_input_field.dart';
import 'package:whisper/details/user_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/user_search/user_search_model.dart';

class UserList extends StatelessWidget {

  UserList({
    Key? key,
    required this.results,
    required this.mainModel,
    required this.userSearchModel
  }) : super(key: key);

  final List<AlgoliaObjectSnapshot> results;
  final MainModel mainModel;
  final UserSearchModel userSearchModel;
  
  @override 
  Widget build(BuildContext context) {

    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: userSearchModel.searchTerm,
        selection: TextSelection.collapsed(
          offset: userSearchModel.searchTerm.length
        )
      )
    );

    return Column(
      children: [
        SearchInputField(
          onLongPress: () async { await FlutterClipboard.paste().then((value) { userSearchModel.searchTerm = value; }); },
          onChanged: (text) {
            userSearchModel.searchTerm = text;
          },
          controller: searchController, 
          search: () async {
            await userSearchModel.operation(mainModel.mutesUids,mainModel.blocksUids);
          }
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, int i) =>
            UserCard(result: results[i].data, mainModel: mainModel)
          )
        ),
      ],
    );
  }
}