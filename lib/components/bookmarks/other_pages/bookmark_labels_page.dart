// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/constants/others.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/details/gradient_screen.dart';
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
    final height = MediaQuery.of(context).size.height;

    return bookmarksModel.isBookmarkMode ?
    BookmarksPage(mainModel: mainModel, bookmarksModel: bookmarksModel) : 
    Scaffold(
      body: GradientScreen(
          top: SizedBox.shrink(), 
          header: Padding(
          padding: EdgeInsets.all(height/32.0),
          child: Text(
            'リストを選択',
            style: TextStyle(
              color: Colors.white,
              fontSize: height/32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        circular: height/32.0,
        content: ListView.builder(
          itemCount: mainModel.bookmarkLabels.length,
          itemBuilder: (BuildContext context, int i) {
            final BookmarkLabel bookmarkLabel = mainModel.bookmarkLabels[i];
            return ListTile(
              leading: Icon(Icons.list),
              trailing: InkWell(
                child: Icon(Icons.edit),
                onTap: () {
                  final TextEditingController labelEditingController = TextEditingController(text: bookmarkLabel.label);
                  final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder = (context,controller,_) {
                    return TextButton(
                      onPressed: () async {
                        await bookmarksModel.onUpdateLabelButtonPressed(flashController: controller, bookmarkLabel: bookmarkLabel, userMeta: mainModel.userMeta );
                      }, 
                      child: Text('OK',style: textStyle(context: context),)
                    );
                  };
                  final Widget content = TextFormField(
                    controller: labelEditingController,
                    onChanged: (text) {
                      bookmarksModel.editLabel = text;
                    },
                  );
                  voids.showFlashDialogue(context: context, content: content, titleText: 'ラベルを編集', positiveActionBuilder: positiveActionBuilder);
                },
              ),
              title: Text(bookmarkLabel.label,style: TextStyle(fontSize: height/32.0,),),
              onTap: () async {
                await bookmarksModel.init(context: context, mainModel: mainModel, bookmarkLabel: bookmarkLabel);
              },
            );
          }
        ) 
      ),
    );
  }
}
