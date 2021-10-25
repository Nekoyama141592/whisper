// material
import 'package:flutter/material.dart';

class H2Text extends StatelessWidget {

  const H2Text({
    Key? key,
    required this.text
  }) : super(key: key);

  final String text;

  @override 

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0
        ),
      ),
    );
  }
}