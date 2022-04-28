// material
import 'package:flutter/material.dart';
// packages
import 'package:flash/flash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisper/components/bookmarks/bookmarks_page.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/strings.dart';
// constants
import 'package:whisper/constants/voids.dart' as voids;
import 'package:whisper/constants/widgets.dart';
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/details/positive_text.dart';
// domain
import 'package:whisper/domain/bookmark_post_category/bookmark_post_category.dart';
import 'package:whisper/l10n/l10n.dart';
// model
import 'package:whisper/main_model.dart';
import 'package:whisper/components/bookmarks/bookmarks_model.dart';

class BookmarkCategoriesPage extends ConsumerWidget {
  
  const BookmarkCategoriesPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);
  
  final MainModel mainModel;

  @override 
  Widget build(BuildContext context,WidgetRef ref ) {

    final bookmarksModel = ref.watch(bookmarksProvider);
    final height = MediaQuery.of(context).size.height;
    final L10n l10n = returnL10n(context: context)!;
    return bookmarksModel.isBookmarkMode ?
    BookmarksPage(mainModel: mainModel, bookmarksModel: bookmarksModel) : 
    Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.new_label,color: Colors.white,),
        onPressed: () async {
          final TextEditingController textEditingController = TextEditingController(text: bookmarksModel.newLabel);
          final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder = (context,controller,_) {
            return TextButton(
              onPressed: () async=> await bookmarksModel.addBookmarkPostLabel(mainModel: mainModel, context: context, flashController: controller),
              child: PositiveText(text: okText)
            );
          };
          final Widget content = TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: l10n.categoryExample,
              suffixIcon: InkWell(
                child: Icon(Icons.close),
                onTap: () {
                  textEditingController.text = '';
                  bookmarksModel.newLabel = '';
                },
              )
            ),
            onChanged: (text) => bookmarksModel.newLabel = text,
          );
          voids.showFlashDialogue(context: context, content: content, titleText: l10n.createCategory, positiveActionBuilder: positiveActionBuilder);
        },
      ),
      body: GradientScreen(
          top: SizedBox.shrink(), 
          header: Padding(
          padding: EdgeInsets.all(defaultPadding(context: context)),
          child: whiteBoldEllipsisHeaderText(context: context,text: l10n.selectCategory ),
        ),
        circular: height/32.0,
        content: ListView.builder(
          itemCount: mainModel.bookmarkPostCategories.length,
          itemBuilder: (BuildContext context, int i) {
            final BookmarkPostCategory bookmarkLabel = mainModel.bookmarkPostCategories[i];
            return ListTile(
              leading: Icon(Icons.list),
              trailing: InkWell(
                child: Icon(Icons.edit),
                onTap: () {
                  final TextEditingController labelEditingController = TextEditingController(text: bookmarkLabel.categoryName);
                  final Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? positiveActionBuilder = (context,controller,_) {
                    return TextButton(
                      onPressed: () async => await bookmarksModel.onUpdateLabelButtonPressed(context: context,flashController: controller, bookmarkPostCategory: bookmarkLabel, userMeta: mainModel.userMeta ),
                      child: PositiveText(text: okText)
                    );
                  };
                  final Widget content = TextFormField(
                    controller: labelEditingController,
                    decoration: InputDecoration(
                      hintText: l10n.categoryExample,
                      suffixIcon: InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          labelEditingController.text = '';
                          bookmarksModel.editLabel = '';
                        },
                      )
                    ),
                    onChanged: (text) {
                      bookmarksModel.editLabel = text;
                    },
                  );
                  voids.showFlashDialogue(context: context, content: content, titleText: l10n.editCategory, positiveActionBuilder: positiveActionBuilder);
                },
              ),
              title: boldEllipsisText(text: bookmarkLabel.categoryName),
              onTap: () async => await bookmarksModel.init(context: context, mainModel: mainModel, bookmarkLabel: bookmarkLabel)
            );
          }
        ) 
      ),
    );
  }
}
