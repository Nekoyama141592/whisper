// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/others.dart';

class PositiveText extends StatelessWidget {

  const PositiveText({
    Key? key,
    required this.text
  }) : super(key: key);

  final String text;

  @override 
  Widget build(BuildContext context) {
    return Text(text,style: textStyle(context: context),);
  }
}