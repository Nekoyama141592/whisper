// material
import 'package:flutter/material.dart';

class CommentsOrReplysHeader extends StatelessWidget {

  const CommentsOrReplysHeader({
    Key? key,
    required this.onMenuPressed
  }) : super(key: key);

  final void Function()? onMenuPressed;

  @override 

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          InkWell(
            child: Icon(Icons.arrow_back,size: 32.0,),
            onTap: () { Navigator.pop(context); },
          ),
          Expanded(child: SizedBox()),
          InkWell(
            child: Icon(Icons.menu_open,size: 32.0,),
            onTap: onMenuPressed,
          )
        ],
      ),
    );
  }
}