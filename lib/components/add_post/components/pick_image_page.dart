import 'package:flutter/material.dart';

import 'package:whisper/components/add_post/add_post_model.dart';
import 'package:whisper/constants/colors.dart';

import 'package:whisper/details/rounded_button.dart';
class PickImagePage extends StatelessWidget {
  PickImagePage({
    Key? key,
    required this.addPostModel
  }) : super(key: key);

  final AddPostModel addPostModel;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image),
            
          ],
        ),
      ),
    );
  }
}