// material
import 'package:flutter/material.dart';

class BackArrowButton extends StatelessWidget {

  @override 
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.height/75.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () => Navigator.pop(context)
          ),
        ],
      ),
    );
  }
}