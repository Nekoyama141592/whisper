// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/search/post_search/components/post_list.dart';
import 'package:whisper/components/search/post_search/components/search_input_field.dart';
// model
import 'post_search_model.dart';

class PostSearchPage extends ConsumerWidget {
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final searchModel = watch(searchProvider);
    final results = searchModel.results;
    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: searchModel.searchTerm,
        selection: TextSelection.collapsed(
          offset: searchModel.searchTerm.length
        )
      )
    );
    return Column(
      children: [
        SearchInputField(
          searchModel: searchModel, 
          controller: searchController, 
          press: () async {
            await searchModel.operation();
          }
        ),
        searchModel.isLoading ?
        Loading() : PostList(results: results)
      ],
    );
  }
}