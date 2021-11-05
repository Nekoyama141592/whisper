// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/search/post_search/components//post_cards.dart';
import 'package:whisper/components/search/post_search/components/search_input_field.dart';
// model
import 'post_search_model.dart';
import 'package:whisper/main_model.dart';

class PostSearchPage extends ConsumerWidget {

  const PostSearchPage({
    Key? key,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);

  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final searchModel = watch(postSearchProvider);
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
            await searchModel.operation(mainModel.mutesUids,mainModel.mutesPostIds,mainModel.blockingUids);
          }
        ),
        searchModel.isLoading ?
        Loading() 
        : Expanded(
          child: PostCards(
            results: searchModel.results,
            mainModel: mainModel,
            postSearchModel: postSearchModel,
          ),
        )
      ],
    );
  }
}