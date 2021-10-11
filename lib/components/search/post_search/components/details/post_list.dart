// material
import 'package:flutter/material.dart';
// components
import 'post_result.dart';
import 'package:whisper/details/nothing.dart';
import 'package:whisper/components/search/post_search/components/audio_window/audio_window.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/search/post_search/post_search_model.dart';

class PostList extends StatelessWidget {

  const PostList({
    Key? key,
    required this.results,
    required this.mainModel,
    required this.postSearchModel,
  }) : super(key: key);

  final List<Map<String,dynamic>> results;
  final MainModel mainModel;
  final PostSearchModel postSearchModel;
  
  @override 
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return results.isEmpty ?
    Column(
      children: [
        SizedBox(height: size.height * 0.16,),
        Nothing(),
      ],
    )
    : SizedBox(
      height: size.height * 0.65,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (BuildContext context, int i) =>
              PostResult(
                result: results[i],
                i: i,
                mainModel: mainModel,
                postSearchModel: postSearchModel
              )
            )
          ),
         AudioWindow(mainModel: mainModel, postSearchModel: postSearchModel)
        ],
      ),
    );
  }
}