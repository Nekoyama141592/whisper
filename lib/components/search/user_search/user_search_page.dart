import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/components/search/user_search/components/user_list.dart';
import 'package:whisper/components/search/user_search/components/search_input_field.dart';
import 'user_search_model.dart';

class UserSearchPage extends ConsumerWidget {

  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final _searchProvider = watch(searchProvider);
    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: _searchProvider.searchTerm,
        selection: TextSelection.collapsed(
          offset: _searchProvider.searchTerm.length
        )
      )
    );
    return Column(
      children: [
        SearchInputField(
          _searchProvider, 
          searchController, 
          () async {
            await _searchProvider.operation();
          }
        ),
        !_searchProvider.isLoading ?
        UserList(
          _searchProvider.results
        )
        : Text('Loading')
      ],
    );
  }
}