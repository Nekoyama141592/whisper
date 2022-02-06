// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';
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
        SizedBox(width: defaultPadding(context: context)/2.0 ),  
      ],
    );
  }
}