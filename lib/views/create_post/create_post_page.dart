// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/constants/widgets.dart';
// components
import 'package:whisper/details/gradient_screen.dart';
import 'package:whisper/l10n/l10n.dart';
import 'package:whisper/main_model.dart';
// model
import '../../models/main/create_post_model.dart';
import 'package:whisper/views/create_post/create_post_content/components/create_post_content.dart';

class CreatePostPage extends StatelessWidget {

  CreatePostPage({
    Key? key,
    required this.mainModel,
    required this.addPostModel
  }) : super(key: key);

  final MainModel mainModel;
  final CreatePostModel addPostModel;
  
  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final L10n l10n = returnL10n(context: context)!;
    return Scaffold(
      body: GradientScreen(
        top: Row(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                color: Theme.of(context).focusColor,
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context)
              ),
            ),
          ],
        ),
        header: Padding(
          padding: EdgeInsets.all(height/75.0),
          child: boldEllipsisHeaderText(context: context,text: l10n.makePost),
        ),
        child: CreatePostContent(addPostModel: addPostModel, mainModel: mainModel),
        circular: defaultPadding(context: context),
      ),
    );
  }
}
