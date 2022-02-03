// material
import 'package:flutter/material.dart';
// model
import 'package:whisper/main_model.dart';


class CommentButton extends StatelessWidget {

  CommentButton({
    Key? key,
    required this.toCommentsPage,
    required this.mainModel
  }) : super(key: key);

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