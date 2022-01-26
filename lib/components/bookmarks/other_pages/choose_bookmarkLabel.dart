// material
import 'package:flutter/material.dart';
// domain
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
// model
import 'package:whisper/main_model.dart';

class ChooseBookmarkLabelPage extends StatelessWidget {
  
  const ChooseBookmarkLabelPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);
  
  final MainModel mainModel;
  @override 
  Widget build(BuildContext context) {
    final bookmarkLabels = mainModel.bookmarkLabels;
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

