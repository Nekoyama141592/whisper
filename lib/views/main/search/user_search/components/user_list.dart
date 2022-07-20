// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// components
import 'package:whisper/details/search_input_field.dart';
import 'package:whisper/details/user_card.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/user_search_model.dart';

class UserList extends StatelessWidget {

  UserList({
    Key? key,
    required this.results,
    required this.mainModel,
    required this.userSearchModel
  }) : super(key: key);

  final List<DocumentSnapshot<Map<String,dynamic>>> results;
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
          onCloseButtonPressed: () {
            userSearchModel.searchTerm = '';
            searchController.text = '';
          },
          onLongPress: () async => await FlutterClipboard.paste().then((value) { userSearchModel.searchTerm = value; }),
          onChanged: (text) => userSearchModel.searchTerm = text,
          controller: searchController, 
          search: () async => await userSearchModel.operation(context: context, mutesUids: mainModel.muteUids, blocksUids: mainModel.blockUids)
        ),
        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, int i) =>
            UserCard(result: results[i].data()!, mainModel: mainModel)
          )
        ),
      ],
    );
  }
}