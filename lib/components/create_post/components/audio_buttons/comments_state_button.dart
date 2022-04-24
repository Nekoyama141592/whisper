// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';
// components
import 'package:whisper/components/create_post/components/audio_buttons/audio_button.dart';
//model
import 'package:whisper/components/create_post/create_post_model.dart';

class CommentsStateButton extends StatelessWidget {

  const CommentsStateButton({
    Key? key,
    required this.addPostModel
  }) : super(key: key);

  final CreatePostModel addPostModel;

  @override 
  Widget build(BuildContext context) {
    
    return ValueListenableBuilder<String>(
      valueListenable: addPostModel.commentsStateDisplayNameNotifier,
      builder: (_,commentsStateDisplayName,__) {
        
        return AudioButton(
          description: commentsStateDisplayName, 
          icon: Icon(Icons.comment,color: Theme.of(context).focusColor,size: addPostIconSize(context: context), ),
          press: () => addPostModel.showCommentStatePopUp(context: context),
        );
      }
    );
  }
}