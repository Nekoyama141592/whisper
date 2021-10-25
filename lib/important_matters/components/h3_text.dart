// material
import 'package:flutter/material.dart';

class H3Text extends StatelessWidget {

  const H3Text({
    Key? key,
    required this.text
  }) : super(key: key);

  final String text;

  @override 

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}