// material
import 'package:flutter/material.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';
// components
import 'package:whisper/details/loading.dart';
import 'package:whisper/components/bookmarks/components/post_screen.dart';
// model
import 'package:whisper/main_model.dart';
// main.dart
import 'package:whisper/main.dart';

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
    
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        body: bookmarksModel.isLoading ? Loading() : PostScreen(bookmarksModel: bookmarksModel, mainModel: mainModel, ),
      ),
    );
  }
}

