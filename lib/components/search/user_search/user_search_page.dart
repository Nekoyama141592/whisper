// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/search/user_search/components/user_list.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/user_search/user_search_model.dart';

class UserSearchPage extends ConsumerWidget {

  const UserSearchPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;
  @override 
  Widget build(BuildContext context, ScopedReader watch) {
    final userSearchModel = watch(searchProvider);
    final results = userSearchModel.results;
    
    return userSearchModel.isLoading ?
    Loading() : UserList(results: results, mainModel: mainModel,userSearchModel: userSearchModel,);
  }
}