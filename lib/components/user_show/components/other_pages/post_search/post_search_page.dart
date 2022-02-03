// material
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:whisper/details/loading.dart';
import 'components/post_cards.dart';
import 'package:whisper/domain/whisper_user/whisper_user.dart';
// model
import 'post_search_model.dart';
import 'package:whisper/main_model.dart';

class PostSearchPage extends ConsumerWidget {

  const PostSearchPage({
    Key? key,
    required this.passiveWhisperUser,
    required this.mainModel,
    required this.postSearchModel
  }) : super(key: key);

  final WhisperUser passiveWhisperUser;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context, WidgetRef ref) {
    final searchModel = ref.watch(postSearchProvider);
    
    return searchModel.isLoading ?
    Loading() 
    : PostCards(
      passiveWhisperUser: passiveWhisperUser,
      results: searchModel.results,
      mainModel: mainModel,
      postSearchModel: postSearchModel,
    );
  }
}