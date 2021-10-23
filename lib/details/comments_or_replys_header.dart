// material
import 'package:flutter/material.dart';

class CommentsOrReplysHeader extends StatelessWidget {

  const CommentsOrReplysHeader({
    Key? key,
    required this.onBackButtonPressed,
    required this.onMenuPressed
  }) : super(key: key);

  final void Function()? onBackButtonPressed;
  final void Function()? onMenuPressed;

  @override 

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.arrow_back),
            onTap: onBackButtonPressed,
          ),
          Expanded(child: SizedBox()),
          InkWell(
            child: Icon(Icons.menu_open),
            onTap: onMenuPressed,
          )
        ],
      ),
    );
  }
}