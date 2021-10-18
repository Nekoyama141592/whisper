// material
import 'package:flutter/material.dart';
// components
import 'package:whisper/components/add_post/components/audio_buttons/audio_button.dart';
//model
import 'package:whisper/components/add_post/add_post_model.dart';

class CommentsStateButton extends StatelessWidget {

  const CommentsStateButton({
    Key? key,
    required this.addPostModel
  }) : super(key: key);

  final AddPostModel addPostModel;

  @override 
  Widget build(BuildContext context) {
    
    return ValueListenableBuilder<String>(
      valueListenable: addPostModel.commentsStateDisplayNameNotifier,
      builder: (_,commentsStateDisplayName,__) {
        return Column(
          children: [
            IconButton(
              iconSize: 100,
              tooltip: commentsStateDisplayName,
              icon: Icon(
                Icons.comment,
                color: Theme.of(context).focusColor,
              ),
              onPressed: () {
                addPostModel.showCommentStatePopUp(context);
              }, 
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5
              ),
              child: Text(
                commentsStateDisplayName,
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        );
      }
    );
  }
}