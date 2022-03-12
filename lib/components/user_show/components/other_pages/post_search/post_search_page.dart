// material
import 'package:flutter/material.dart';
// package
import 'package:clipboard/clipboard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/details/judge_screen.dart';
// components
import 'components/post_cards.dart';
import 'package:whisper/details/loading.dart';
import 'package:whisper/details/search_input_field.dart';
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
    final size = MediaQuery.of(context).size;
    final searchController = TextEditingController.fromValue(
      TextEditingValue(
        text: postSearchModel.searchTerm,
        selection: TextSelection.collapsed(
          offset: postSearchModel.searchTerm.length
        )
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(passiveWhisperUser.userName,),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(size.height/32.0),
        ),
      ),
      ),
      body: SafeArea(
        child: searchModel.isLoading ?
        Loading() 
        : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: SearchInputField(
                onCloseButtonPressed: () {
                  searchController.text = '';
                  postSearchModel.searchTerm = '';
                },
                onLongPress: () async { await FlutterClipboard.paste().then((value) { postSearchModel.searchTerm = value; }); },
                onChanged: (text) {
                  postSearchModel.searchTerm = text;
                },
                controller: searchController, 
                search: () async {
                  await postSearchModel.search(context: context, mainModel: mainModel, passiveWhisperUser: passiveWhisperUser);
                }
              ),
            ),
            if (searchModel.results.isEmpty) SizedBox(height: size.height * 0.16,),
            JudgeScreen(
              list: postSearchModel.results, 
              content: PostCards(
                passiveWhisperUser: passiveWhisperUser,
                results: searchModel.results,
                mainModel: mainModel,
                postSearchModel: postSearchModel,
              ), 
              reload: () async {
                await postSearchModel.onReload(context: context, mainModel: mainModel, passiveWhisperUser: passiveWhisperUser);
              }
            ),
          ],
        )
      ),
    );
  }
}