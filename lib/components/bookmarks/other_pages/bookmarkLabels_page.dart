// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/details/loading.dart';
// domain
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
// model
import 'package:whisper/main_model.dart';

class BookmarkLabelsPage extends StatelessWidget {
  
  const BookmarkLabelsPage({
    Key? key,
    required this.mainModel,
    required this.bookmarkLabels
  }) : super(key: key);
  
  final MainModel mainModel;
  final List<BookmarkLabel> bookmarkLabels;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: bookmarkLabels.length,
        itemBuilder: (BuildContext context, int i) {
          final BookmarkLabel bookmarkLabel = bookmarkLabels[i];
          return ListTile(title: Text(bookmarkLabel.label),);
        }
      )
    );
  }
}
