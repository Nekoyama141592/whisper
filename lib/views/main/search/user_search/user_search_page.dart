// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/views/main/search/user_search/components/user_list.dart';
// models
import 'package:whisper/main_model.dart';
import 'package:whisper/models/main/user_search_model.dart';

class UserSearchPage extends ConsumerWidget {

  const UserSearchPage({
    Key? key,
    required this.mainModel
  }) : super(key: key);

  final MainModel mainModel;
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final userSearchModel = ref.watch(searchProvider);
    final results = userSearchModel.results;
    
    return userSearchModel.isLoading ?
    SizedBox.shrink() : UserList(results: results, mainModel: mainModel,userSearchModel: userSearchModel,);
  }
}