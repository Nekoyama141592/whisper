// material
import 'package:flutter/material.dart';
import 'package:whisper/models/main/bookmarks_model.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/views/main/bookmarks/components/post_screen.dart';
// model
import 'package:whisper/main_model.dart';

class BookmarksPage extends StatelessWidget {
  
  const BookmarksPage({
    Key? key,
    required this.mainModel,
    required this.bookmarksModel
  }) : super(key: key);
  
  final MainModel mainModel;
  final BookmarksModel bookmarksModel;

  @override 
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: bookmarksModel.isLoading ? Loading() : PostScreen(bookmarksModel: bookmarksModel, mainModel: mainModel, ),
    );
  }
}

