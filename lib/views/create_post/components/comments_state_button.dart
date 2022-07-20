// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/views/create_post/components/audio_button.dart';
//model
import 'package:whisper/models/main/create_post_model.dart';
import 'package:whisper/constants/others.dart';
import 'package:whisper/l10n/l10n.dart';

class CommentsStateButton extends StatelessWidget {

  const CommentsStateButton({
    Key? key,
    required this.createPostModel
  }) : super(key: key);

  final CreatePostModel createPostModel;

  @override 
  Widget build(BuildContext context) {
    final L10n l10n = returnL10n(context: context)!;
    return ValueListenableBuilder<String>(
      valueListenable: createPostModel.commentsStateDisplayNameNotifier,
      builder: (_,commentsStateDisplayName,__) {
        
        return AudioButton(
          description: commentsStateDisplayName.isEmpty ? l10n.commentsStateIsOpenText : commentsStateDisplayName, 
          icon: Icon(Icons.comment,color: Theme.of(context).focusColor,size: addPostIconSize(context: context), ),
          press: () => createPostModel.showCommentStatePopUp(context: context),
        );
      }
    );
  }
}