// material
import 'package:flutter/material.dart';

class NoRight extends StatelessWidget {

  const NoRight({
    Key? key
  }) : super(key: key);
  
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