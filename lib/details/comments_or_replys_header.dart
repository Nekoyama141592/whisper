// material
import 'package:flutter/material.dart';
import 'package:whisper/constants/doubles.dart';

class CommentsOrReplysHeader extends StatelessWidget {

  const CommentsOrReplysHeader({
    Key? key,
    required this.onMenuPressed
  }) : super(key: key);

  final void Function()? onMenuPressed;

  @override 

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultPadding(context: context)),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.arrow_back,size: defaultPadding(context: context) * 2,),
            onTap: () => Navigator.pop(context),
          ),
          Expanded(child: SizedBox()),
          InkWell(
            child: Icon(Icons.menu_open,size: defaultPadding(context: context) * 2,),
            onTap: onMenuPressed,
          )
        ],
      ),
    );
  }
}