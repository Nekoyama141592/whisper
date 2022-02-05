// material
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:whisper/constants/routes.dart';
// domain
import 'package:whisper/domain/bookmark_label/bookmark_label.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

class BookmarkLabelsPage extends ConsumerWidget {
  
  const BookmarkLabelsPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);
  
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref ) {

    final bookmarksModel = ref.watch(bookmarksProvider);

    return Scaffold(
      body: ListView.builder(
        itemCount: mainModel.bookmarkLabels.length,
        itemBuilder: (BuildContext context, int i) {
          final BookmarkLabel bookmarkLabel = mainModel.bookmarkLabels[i];
          return ListTile(
            title: Text(bookmarkLabel.label),
            onTap: () async {
              toBookmarksPage(context: context, mainModel: mainModel, bookmarksModel: bookmarksModel);
              await bookmarksModel.init(context: context, mainModel: mainModel, bookmarkLabel: bookmarkLabel);
            },
          );
        }
      )
    );
  }
}
