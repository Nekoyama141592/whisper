import 'package:flutter/material.dart';
import 'package:whisper/constants/colors.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  TextFieldContainer(this.child);

  @override  
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      width: size.width * 0.8 ,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(30)
      ),
      child: child,
    );
  }
}