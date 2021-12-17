// material
import 'package:flutter/material.dart';
// packages

// models
import 'package:whisper/main_model.dart';


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.currentSongMap,
    required this.toCommentsPage,
    required this.mainModel
  }) : super(key: key);

  final Map<String,dynamic> currentSongMap;
  final void Function()? toCommentsPage;
  final MainModel mainModel;

  @override  
  Widget build(BuildContext context) {
        return Row(
          children: [
            InkWell(
              child: Icon(Icons.comment),
              onTap: toCommentsPage,
            ),
            SizedBox(width: 5.0),
            
          ],
        );
    
  }
}