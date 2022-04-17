// material
import 'package:flutter/material.dart';
// constants
import 'package:whisper/constants/doubles.dart';

class Indicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding(context: context) ),
          child: LinearProgressIndicator(),
        )
      ],
    );
  }
}