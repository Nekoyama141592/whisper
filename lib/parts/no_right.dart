import 'package:flutter/material.dart';

class NoRight extends StatelessWidget {
  @override  
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text('You don`t have right to access this page'),
        )
      ],
    );
  }
}