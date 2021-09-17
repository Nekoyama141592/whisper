import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:whisper/parts/algolia/components/post_card.dart';
import 'package:whisper/parts/algolia/components/search_input_field.dart';
import 'search_model.dart';

class SearchPage extends ConsumerWidget {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
        ),
        body: Column(
          children: [
            SearchInputField(
              _searchProvider,
              searchController,
              () async {
                await _searchProvider.operation(
                  _searchProvider.searchTerm
                );
              }
            ),
            !_searchProvider.isLoading ?
            Expanded(
              // child:  _searchProvider.searchTerm.length > 0 ?
              child:
              ListView.builder(
                itemCount: _searchProvider.results.length,
                itemBuilder: (context, i) {
                  return _searchProvider.results.isNotEmpty ?
                  PostCard(
                    _searchProvider.results[i].data
                  )
                  : Text('Something is wrond');
                }
              )
              
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Loading')
              ],
            )
          ]
        ),
      ),
    );
  }
}